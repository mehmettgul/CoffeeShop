//
//  CategoryData.swift
//  CoffeeShop
//
//  Created by Mehmet Gül on 18.08.2023.
//

import Foundation

class CategoryData {
    
    struct CategoryData {
        var categoryId: Int16
        var categoryName: String
    }
    
    let categoryData: [CategoryData] = [
        CategoryData(categoryId: 0, categoryName: "Tümü"),
        CategoryData(categoryId: 1, categoryName: "Espressolu"),
        CategoryData(categoryId: 2, categoryName: "Sıcaklar"),
        CategoryData(categoryId: 3, categoryName: "Soğuklar"),
        CategoryData(categoryId: 4, categoryName: "Çaylar"),
        CategoryData(categoryId: 5, categoryName: "Özeller")
    ]
    
}
