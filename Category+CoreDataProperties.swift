//
//  Category+CoreDataProperties.swift
//  CoffeeShop
//
//  Created by Mehmet Gül on 21.08.2023.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var categoryId: UUID?
    @NSManaged public var categoryName: String?
    @NSManaged public var coffees: [Coffee]?
    @NSManaged public var coffeeEntity: Coffee?

}

extension Category : Identifiable {

}
