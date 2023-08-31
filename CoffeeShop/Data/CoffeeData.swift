//
//  CoffeeData.swift
//  CoffeeShop
//
//  Created by Mehmet Gül on 14.08.2023.
//

import Foundation
import CoreData

class CoffeeData {
    
    let categoryData: [CategoryData.CategoryData] // Kategori verilerini burada tanımlıyoruz
        
    init() {
        self.categoryData = CategoryData().categoryData // Kategori verilerini çekmek için CategoryData sınıfını kullanıyoruz.
    }
    
    struct CoffeeData {
        var categoryId : Int16
        var coffeeId: Int16
        var name: String
        var price: Int16
    }
    
    lazy var coffees: [CoffeeData] = [
        CoffeeData(categoryId: categoryData[1].categoryId ,coffeeId: 0, name: "Caffe Latte", price: 45),
        CoffeeData(categoryId: categoryData[1].categoryId ,coffeeId: 1, name: "White Chocolate Mocha", price: 62),
        CoffeeData(categoryId: categoryData[1].categoryId ,coffeeId: 2, name: "Latte Macchiato", price: 45),
        CoffeeData(categoryId: categoryData[1].categoryId ,coffeeId: 3, name: "Cappuccino", price: 45),
        CoffeeData(categoryId: categoryData[1].categoryId ,coffeeId: 4, name: "Espresso Con Panna", price: 35),
        CoffeeData(categoryId: categoryData[2].categoryId ,coffeeId: 5, name: "Hot Chocolate", price: 54),
        CoffeeData(categoryId: categoryData[2].categoryId ,coffeeId: 6, name: "Chai Tea Latte", price: 53),
        CoffeeData(categoryId: categoryData[2].categoryId ,coffeeId: 7, name: "Caramel Macchiato", price: 40),
        CoffeeData(categoryId: categoryData[2].categoryId ,coffeeId: 8, name: "Mocha Latte", price: 48),
        CoffeeData(categoryId: categoryData[2].categoryId ,coffeeId: 9, name: "Vanilla Latte", price: 42),
        CoffeeData(categoryId: categoryData[3].categoryId ,coffeeId: 10, name: "Iced Coffee", price: 40),
        CoffeeData(categoryId: categoryData[3].categoryId ,coffeeId: 11, name: "Iced Latte", price: 50),
        CoffeeData(categoryId: categoryData[3].categoryId ,coffeeId: 12, name: "Iced Mocha", price: 55),
        CoffeeData(categoryId: categoryData[3].categoryId ,coffeeId: 13, name: "Iced Americano", price: 42),
        CoffeeData(categoryId: categoryData[3].categoryId ,coffeeId: 14, name: "Iced Tea", price: 35),
        CoffeeData(categoryId: categoryData[4].categoryId ,coffeeId: 15, name: "Black Tea", price: 30),
        CoffeeData(categoryId: categoryData[4].categoryId ,coffeeId: 16, name: "Green Tea", price: 30),
        CoffeeData(categoryId: categoryData[4].categoryId ,coffeeId: 17, name: "Chamomile Tea", price: 32),
        CoffeeData(categoryId: categoryData[4].categoryId ,coffeeId: 18, name: "Earl Grey Tea", price: 32),
        CoffeeData(categoryId: categoryData[4].categoryId ,coffeeId: 19, name: "Peppermint Tea", price: 32),
        CoffeeData(categoryId: categoryData[5].categoryId ,coffeeId: 20, name: "Turkish Coffee", price: 28),
        CoffeeData(categoryId: categoryData[5].categoryId ,coffeeId: 21, name: "Flat White", price: 40),
        CoffeeData(categoryId: categoryData[5].categoryId ,coffeeId: 22, name: "Irish Coffee", price: 45),
        CoffeeData(categoryId: categoryData[5].categoryId ,coffeeId: 23, name: "Cortado", price: 38),
        CoffeeData(categoryId: categoryData[5].categoryId ,coffeeId: 24, name: "Affogato", price: 40)
    ]
}
