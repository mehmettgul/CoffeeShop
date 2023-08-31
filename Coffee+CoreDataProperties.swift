//
//  Coffee+CoreDataProperties.swift
//  CoffeeShop
//
//  Created by Mehmet Gül on 21.08.2023.
//
//

import Foundation
import CoreData


extension Coffee {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Coffee> {
        return NSFetchRequest<Coffee>(entityName: "Coffee")
    }

    @NSManaged public var categoryId: UUID?
    @NSManaged public var coffeeId: Int16
    @NSManaged public var name: String?
    @NSManaged public var price: Int16
    @NSManaged public var parentEntity: Category?

}

extension Coffee : Identifiable {

}
