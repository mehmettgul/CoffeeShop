//
//  PaymentViewmodel.swift
//  CoffeeShop
//
//  Created by Mehmet Gül on 31.08.2023.
//

import Foundation
import CoreData
import UIKit

class PaymentViewmodel {
    
    var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func fetchCreditCards() -> [CreditCard]? {
        let fetchRequest: NSFetchRequest<CreditCard> = CreditCard.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "creditCardId", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            let creditCards = try context.fetch(fetchRequest)
            print("Credit cards fetched.")
            return creditCards
        } catch {
            print("Error fetching credit cards: \(error)")
            return nil
        }
    }
    
    func saveCreditCardBalance(creditCardId: Int16, creditCardBalance: Int16) {
        let fetchRequest: NSFetchRequest<CreditCard> = CreditCard.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "creditCardId == \(creditCardId)", true) // Özel bir koşula göre arama yapabilirsiniz
        do {
            let fetchedCards = try context.fetch(fetchRequest)
            if let cardToUpdate = fetchedCards.first {
                cardToUpdate.creditCardBalance = creditCardBalance
            }
            try context.save() // Değişiklikleri kaydet
            print("Bakiye güncellendi.")
        } catch {
            print("Bakiye güncelleme hatası: \(error)")
        }
    }
    
    func fetchAddresses() -> [Address]? {
        let fetchRequest: NSFetchRequest<Address> = Address.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "addressId", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            let addresses = try context.fetch(fetchRequest)
            print("Addresses fetched.")
            return addresses
        } catch {
            print("Error fetching addresses: \(error)")
            return nil
        }
    }
    
    func deleteAddress(addressId: UUID) {
        let fetchRequest: NSFetchRequest<Address> = Address.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "addressId == %@", addressId as CVarArg)
        do {
            let result = try context.fetch(fetchRequest)
            if let addressToDelete = result.first {
                context.delete(addressToDelete)
                try context.save()
                print("Adres silindi.")
            } else {
                print("İlgili adres bulunamadı.")
            }
        } catch {
            print("Adres silme hatası: \(error)")
        }
    }
    
}
