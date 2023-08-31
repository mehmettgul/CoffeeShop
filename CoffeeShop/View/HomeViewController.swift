//
//  HomeViewController.swift
//  CoffeeShop
//
//  Created by Mehmet Gül on 14.08.2023.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var CategoryScroll: UIScrollView!
    @IBOutlet weak var ScrollView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var coffeeCategories: [Category] = [] // Kahve kategorilerini çektim.
    var selectedCoffees: [Coffee] = [] // Seçilen kategoriye ait kahveleri tuttum.
    var filteredCoffees: [Coffee] = []
    var fetchData = FetchViewmodel()
    let searchViewmodel = SearchViewmodel()
    var disposeBag = DisposeBag()
    var menus : [Bool] = []
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = .done
        if let firstButton = ScrollView.subviews.first as? UIButton { // İlk butonun rengini kahverengi yaptım.
            firstButton.backgroundColor = .systemBrown
        }
        if let categories = fetchData.fetchCategories() {
            coffeeCategories = categories
            setCategoryButtons()
        }
        if let sortedCoffees = fetchData.fetchCoffees() {
            selectedCoffees = sortedCoffees
        }
        setCollectionView()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchViewmodel.searchCoffees(searchText: searchText)
            .subscribe(onNext: { coffees in
                self.filteredCoffees = coffees
                print("Received coffees: \(coffees)")
            }, onError: { error in
                print("Hata: \(error.localizedDescription)")
            }, onCompleted: {
                print("Process Succesful.")
            })
            .disposed(by: disposeBag)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text, !searchText.isEmpty {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let anotherViewController = storyboard.instantiateViewController(withIdentifier: "searchViewController") as? SearchViewController {
                anotherViewController.receivedCoffees = self.filteredCoffees
                self.navigationController?.pushViewController(anotherViewController, animated: true)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedCoffees.count // Seçilen kategoride kaç tane kahve varsa onların sayısını döndüm.
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listCell", for: indexPath) as? ListCell else { return UICollectionViewCell() }
        let coffee = selectedCoffees[indexPath.row]// seçilen kategoriye ait kahvelerin olduğu diziden veri çekip hücrelere bastırdım.
        cell.setCell(coffee: coffee)
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
    
    func setCollectionView() {
        collectionView.register(UINib(nibName: "ListCell", bundle: nil), forCellWithReuseIdentifier: "listCell")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        layout.minimumInteritemSpacing = 20
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.reloadData()
    }
    
    func setCategoryButtons() {
        
        let buttonWidth: CGFloat = 120
        let buttonHeight: CGFloat = 40
        
        var xOffset: CGFloat = 10
        let yOffset: CGFloat = (ScrollView.frame.height - buttonHeight) / 2 // dikeyde ortalamak için kullandım.
        menus = Array(repeating: false, count: coffeeCategories.count)
        menus[0] = true
        for category in coffeeCategories { // Her bir kategori adını butonlara isim olarak bastırdım.
            let button = UIButton(type: .custom)
            button.setTitle(category.categoryName, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = menus[count] == true  ? .systemBrown : .white
            button.sizeToFit()
            button.layer.cornerRadius = 12
            button.tag = count
            button.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)
            button.frame = CGRect(x: xOffset, y: yOffset, width:buttonWidth, height: buttonHeight)
            ScrollView.addSubview(button)
            xOffset += 120 + 10 // Bu değer her buton oluşturulduğu zaman scroll'u genişletiyor. içinde ne kadar buton oluşursa o kadar büyüyor.
            count += 1
        }
        CategoryScroll.backgroundColor = .white
        ScrollView.frame.size.width = xOffset // Scroll'un içindeki view'ın genişliği.
        CategoryScroll.contentSize = CGSize(width: ScrollView.frame.width, height: CategoryScroll.frame.height)// UIScrollView genişliği
        CategoryScroll.isDirectionalLockEnabled = true // Yatayda kaydırma
        CategoryScroll.isScrollEnabled = true
        collectionView.reloadData()
        
    }
    // butonun isSelected özelliğini kullanarak menus'dan kurtulmaya çalış.
    @objc func categoryButtonTapped(_ sender: UIButton) {
        menus = Array(repeating: false, count: menus.count)
        menus[sender.tag] = true
        for subview in ScrollView.subviews {
            if menus[subview.tag] {
                subview.backgroundColor = .systemBrown
            } else {
                subview.backgroundColor = .white
            }
        }
        sender.backgroundColor = .systemBrown
        if sender.title(for: .normal) == "Tümü" {
            selectedCoffees = fetchData.fetchCoffees()!
        } else {
            if let category = coffeeCategories.first(where: { $0.categoryName == sender.title(for: .normal) }) {
                let categoryId = category.categoryId
                let categoryData = fetchData.fetchCoffeesById(categoryID: categoryId)
                selectedCoffees = categoryData
            }
        }
        collectionView.reloadData()
    }

}
