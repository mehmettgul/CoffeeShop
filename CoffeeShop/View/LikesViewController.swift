//
//  LikesViewController.swift
//  CoffeeShop
//
//  Created by Mehmet Gül on 14.08.2023.
//

import UIKit
import RxSwift
import RxCocoa

class LikesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var likeCollectionView: UICollectionView!
    
    private let viewModel = FavoriteViewmodel()
    private let disposeBag = DisposeBag()
    var favorites: [Coffee] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        likeCollectionView.delegate = self
        likeCollectionView.dataSource = self
        
        setCollectionView()
        bindToViewModel()
    } // tableView ve CollectionView ile RxSwift kullanımı
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchUpdatedFavorites()
    }
    
    private func bindToViewModel() {
        viewModel.favoriteObservable
            .subscribe(onNext: { [weak self] favorites in
                self?.favorites = favorites
                self?.likeCollectionView.reloadData()
            }).disposed(by: disposeBag) // DisposeBag kullanımına dikkat edin.
    }
    
    func setCollectionView() {
        likeCollectionView.register(UINib(nibName: "ListCell", bundle: nil), forCellWithReuseIdentifier: "listCell")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        layout.minimumInteritemSpacing = 20
        likeCollectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listCell", for: indexPath) as? ListCell else { return UICollectionViewCell() }
        
        cell.coffeeImage.image = UIImage(named: "exampleCoffee")
        cell.coffeeName.text = favorites[indexPath.row].name
        cell.coffeePrice.text = "\(favorites[indexPath.row].price)₺"
        cell.addButton.isHidden = true
        for recognizer in cell.gestureRecognizers ?? [] { // like sayfasında like aksiyonu alınmasın diye kaldırma işlemi
            if recognizer is UITapGestureRecognizer {
                cell.removeGestureRecognizer(recognizer)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5.0, left: 20.0, bottom: 5.0, right: 20.0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let cellWidth = (screenWidth - 60) / 2
        let cellHeight: CGFloat = 210
            
        return CGSize(width: cellWidth, height: cellHeight)
    }

}
