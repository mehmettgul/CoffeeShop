//
//  CartViewmodel.swift
//  CoffeeShop
//
//  Created by Mehmet Gül on 28.08.2023.
//

import Foundation
import RxSwift
import RxCocoa
import CoreData
import UIKit

class CartViewmodel {
    
    var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    private let cartSubject = BehaviorRelay<[Coffee]>(value: [])
    var cartObservable: Observable<[Coffee]> { // Favori kahve listesi değiştiğinde bu değişimi kullanacak yapılara bildirim yapar.
        return cartSubject.asObservable()
    }
    
    func addToCart(_ coffee: Coffee) { // Sepete ekleme işlemini yapar.
        if coffee.inCart == false {
            fetchUpdatedCart()
            var currentCart = cartSubject.value // güncel durum alınır.
            currentCart.append(coffee) // yeni gelen veri güncele yollanır.
            cartSubject.accept(currentCart) // güncel veriyi alır.
            inCartUpdate(coffee: coffee)
            print("Sepete eklendi.")
        } else {
            print("Bu ürün zaten sepete eklenmiş.")
        }
    }
    
    func inCartUpdate(coffee: Coffee) {
        coffee.inCart = true
        do {
            try context.save()
            print("Coffee item in cart.")
        } catch {
            print("coffee item is not in cart: \(error)")
        }
    }
    
    func numberOfCartCoffee(coffeeId: Int16, numberOfCoffee: Int16) {
        let fetchRequest: NSFetchRequest<Coffee> = Coffee.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "inCart == YES AND coffeeId == \(coffeeId)", true)
        do {
            let result = try context.fetch(fetchRequest)
            if let coffee = result.first {
                coffee.numberOfCoffee = numberOfCoffee
                try context.save()
                print("Kahve sayısı kaydedildi.")
            } else {
                print("Kahve sayısı kaydedilmedi.")
            }
        } catch {
            print("Kahve sayısı kaydetme hatası: \(error)")
        }
    }
    
    func fetchUpdatedCart() {
        let fetchRequest: NSFetchRequest<Coffee> = Coffee.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "categoryId", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = NSPredicate(format: "inCart == YES", true)
        do {
            let fetchedCartItems = try context.fetch(fetchRequest)
            cartSubject.accept(fetchedCartItems)
        } catch {
            print("Fetching cart items failed: \(error)")
        }
    }
    
    func deleteCartItems(coffeeId : Int16) {
        let fetchRequest: NSFetchRequest<Coffee> = Coffee.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "inCart == YES AND coffeeId == \(coffeeId)", true)
        do {
            let result = try context.fetch(fetchRequest)
            if let coffeeToDelete = result.first {
                coffeeToDelete.inCart = false
                try context.save()
                print("Kahve sepetten çıkarıldı.")
            } else {
                print("İlgili kahve sepetinizde bulunamadı.")
            }
        } catch {
            print("Kahve silme hatası: \(error)")
        }
    }
    
    func updateCartItemsAfterDelivery(coffees: [Coffee]) {
        for coffee in coffees {
            coffee.inCart = false
        }
        do {
            try context.save()
            print("Kahveler sepetten çıkarıldı.")
        } catch {
            print("Kahve güncelleme hatası: \(error)")
        }
    }
    
}
