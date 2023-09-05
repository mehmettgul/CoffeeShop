//
//  SearchViewController.swift
//  CoffeeShop
//
//  Created by Mehmet Gül on 14.08.2023.
//

import UIKit
import RxSwift

class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var searchCollectionView: UICollectionView!
    var receivedCoffees: [Coffee] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchCollectionView.dataSource = self
        searchCollectionView.delegate = self
        setCollectionView()
        searchCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return receivedCoffees.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listCell", for: indexPath) as? ListCell else { return UICollectionViewCell() }
        let coffee = receivedCoffees[indexPath.row]
        cell.coffeeImage.image = UIImage(named: "exampleCoffee")
        cell.coffeeName.text = coffee.name
        cell.coffeePrice.text = "\(coffee.price) ₺"
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
        let cellWidth = (screenWidth - 60) / 2 // Hücreler arasındaki boşluğu da hesaba katarak genişlik hesabı
        let cellHeight: CGFloat = 210
            
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func setCollectionView() {
        searchCollectionView.register(UINib(nibName: "ListCell", bundle: nil), forCellWithReuseIdentifier: "listCell")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        layout.minimumInteritemSpacing = 20
        searchCollectionView.setCollectionViewLayout(layout, animated: true)
    }
    
}
