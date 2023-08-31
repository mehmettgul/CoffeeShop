//
//  FetchViewmodel.swift
//  CoffeeShop
//
//  Created by Mehmet Gül on 18.08.2023.
//

import Foundation
import UIKit
import CoreData
import RxSwift
import RxCocoa

class FetchViewmodel {
    
    var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func fetchCoffees() -> [Coffee]? {
        let fetchRequest: NSFetchRequest<Coffee> = Coffee.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "coffeeId", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            let coffees = try context.fetch(fetchRequest)
            print("Coffee items fetched.")
            return coffees
        } catch {
            print("Error fetching coffee data: \(error)")
            return nil
        }
    }
    
    func fetchCategories() -> [Category]? {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "categoryId", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            let categories = try context.fetch(fetchRequest)
            print("Category items fetched.")
            return categories
        } catch {
            print("Error fetching category data: \(error)")
            return nil
        }
    }
    
    func fetchCoffeesById(categoryID: Int16) -> [Coffee] {
        let fetchRequest: NSFetchRequest<Coffee> = Coffee.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "coffeeId", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = NSPredicate(format: "categoryId == %d", categoryID)
        do {
            let result = try context.fetch(fetchRequest)
            return result
        } catch {
            print("Hata oluştu: \(error)")
            return []
        }
    }
}
