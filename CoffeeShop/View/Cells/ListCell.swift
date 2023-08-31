//
//  ListCell.swift
//  CoffeeShop
//
//  Created by Mehmet Gül on 15.08.2023.
//

import UIKit

class ListCell: UICollectionViewCell {
    
    @IBOutlet weak var coffeeImage: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var coffeeName: UILabel!
    @IBOutlet weak var coffeePrice: UILabel!
    
    var fetch = FetchViewmodel()
    var cartViewmodel = CartViewmodel()
    var favoriteViewmodel = FavoriteViewmodel()
    var allCoffees: [Coffee] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addButton.layer.cornerRadius = addButton.frame.size.width / 2
        addButton.clipsToBounds = true
    }
    
    func fetchCoffee(categoryId: Int16) {
        allCoffees = fetch.fetchCoffeesById(categoryID: categoryId)
        setupGestureRecognizers()
    }
    
    func setCell(coffee: Coffee) {
        self.coffeeImage.image = UIImage(named: "exampleCoffee")
        self.coffeeName.text = coffee.name
        self.coffeePrice.text = "\(coffee.price)₺"
        self.fetchCoffee(categoryId: coffee.categoryId)
    }
    
   func setupGestureRecognizers() {
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTapGesture.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTapGesture)
    }
    
    @objc private func handleDoubleTap() {
        if let collectionView = superview as? UICollectionView, let indexPath = collectionView.indexPath(for: self) {
            if indexPath.row < allCoffees.count {
                let selectedCoffee = allCoffees[indexPath.row]
                if allCoffees[indexPath.row].coffeeId == selectedCoffee.coffeeId {
                    if selectedCoffee.inFavorite == true {
                        favoriteViewmodel.deleteFavoriteItems(index: indexPath.row)
                    } else {
                        favoriteViewmodel.addToFavorites(selectedCoffee)
                    }
                } else {
                    print("Bu item var.")
                }
            } else {
                print("Bir hata var.")
            }
        }
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        if let collectionView = superview as? UICollectionView, let indexPath = collectionView.indexPath(for: self) {
            if indexPath.row < allCoffees.count {
                let selectedCoffee = allCoffees[indexPath.row]
                if allCoffees[indexPath.row].coffeeId == selectedCoffee.coffeeId {
                    cartViewmodel.addToCart(selectedCoffee)
                } else {
                    print("Bu item var.")
                }
            } else {
                print("Bir hata var.")
            }
        }
    }
    
}
