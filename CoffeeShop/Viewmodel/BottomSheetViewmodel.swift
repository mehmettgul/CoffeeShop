//
//  BottomSheetViewmodel.swift
//  CoffeeShop
//
//  Created by Mehmet Gül on 1.09.2023.
//

import Foundation
import CoreData
import UIKit

class BottomSheetViewmodel {
    
    var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func addAddress(address: String, addressTitle: String) {
        let entity = NSEntityDescription.entity(forEntityName: "Address", in: context)!
        let newAddress = NSManagedObject(entity: entity, insertInto: context)
        newAddress.setValue(UUID(), forKey: "addressId")
        newAddress.setValue(address, forKey: "address")
        newAddress.setValue(addressTitle, forKey: "addressTitle")
        do {
            try context.save()
            print("Address saved.")
        } catch {
            print("Address not save: \(error)")
        }
    }
    
    func editAddress(addressId: UUID, address: String, addressTitle: String) {
        let fetchRequest: NSFetchRequest<Address> = Address.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "addressId == %@", addressId as CVarArg) // Özel bir koşula göre arama yapabilirsiniz
        do {
            let fetchedAddresses = try context.fetch(fetchRequest)
            if let addressToUpdate = fetchedAddresses.first {
                addressToUpdate.addressTitle = "\(address)"
                addressToUpdate.address = "\(addressTitle)"
            }
            try context.save() // Değişiklikleri kaydet
            print("Adres güncellendi.")
        } catch {
            print("Adres güncelleme hatası: \(error)")
        }
    }
    
}
