//
//  CreateDatabase.swift
//  CoffeeShop
//
//  Created by Mehmet Gül on 14.08.2023.
//

import Foundation
import CoreData
import UIKit

class CreateDatabase {
    
    let context: NSManagedObjectContext
        
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func addCoffeeDataToCoreData() {
        let coffeeData = CoffeeData().coffees
        for coffee in coffeeData {
            let newCoffee = Coffee(context: context)
            newCoffee.numberOfCoffee = 1
            newCoffee.categoryId = coffee.categoryId
            newCoffee.name = coffee.name
            newCoffee.price = coffee.price
            newCoffee.coffeeId = coffee.coffeeId
            newCoffee.inCart = false
            newCoffee.inFavorite = false
        }
        do {
            try context.save()
            print("Coffee items saved.")
        } catch {
            print("Error saving coffee data: \(error)")
        }
    }
    
    func addCategoryDataToCoreData() {
        let categoryData = CategoryData().categoryData
        for category in categoryData {
            let newCategory = Category(context: context)
            newCategory.categoryId = category.categoryId
            newCategory.categoryName = category.categoryName
        }
        do {
            try context.save()
            print("Category items saved.")
        } catch {
            print("Error saving category data: \(error)")
        }
    }
    
    func addCreditCartDataToCoreData() {
        let creditCardData = CreditCardData().creditCards
        for creditCard in creditCardData {
            let newCreditCard = CreditCard(context: context)
            newCreditCard.creditCardId = creditCard.creditCardId
            newCreditCard.creditCardName = creditCard.creditCardName
            newCreditCard.creditCardBalance = creditCard.creditCardBalance
            newCreditCard.firstCreditCardNumber = creditCard.firstCreditCardNumber
            newCreditCard.secondCreditCardNumber = creditCard.secondCreditCardNumber
            newCreditCard.thirdCreditCardNumber = creditCard.thirdCreditCardNumber
            newCreditCard.fourthCreditCardNumber = creditCard.fourthCreditCardNumber
            newCreditCard.creditCardExpirationDate = creditCard.creditCardExpirationDate
            newCreditCard.creditCardCVV = creditCard.creditCardCVV
        }
        do {
            try context.save()
            print("Credit cards saved.")
        } catch {
            print("Error saving credit cards: \(error)")
        }
    }
    
//    func addAddressesDataToCoreData() {
//        let addresses = AddressData().addresses
//        for address in addresses {
//            let newAddress = Address(context: context)
//            newAddress.addressId = address.addressId
//            newAddress.address = address.address
//            newAddress.addressTitle = address.addressTitle
//        }
//        do {
//            try context.save()
//            print("Addresses saved.")
//        } catch {
//            print("Error saving addresses: \(error)")
//        }
//    }
    
}
