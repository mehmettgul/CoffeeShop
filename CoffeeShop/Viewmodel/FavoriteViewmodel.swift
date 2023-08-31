//
//  FavoriteViewmodel.swift
//  CoffeeShop
//
//  Created by Mehmet Gül on 28.08.2023.
//

import Foundation
import CoreData
import UIKit
import RxSwift
import RxCocoa

class FavoriteViewmodel {
    
    var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    private let favoriteSubject = BehaviorRelay<[Coffee]>(value: []) // Favori kahveleri sakladığımız yapı.
    var favoriteObservable: Observable<[Coffee]> { // Favori kahve listesi değiştiğinde bu değişimi kullanacak yapılara bildirim yapar.
        return favoriteSubject.asObservable()
    }
    
    func addToFavorites(_ coffee: Coffee) { // Favorilere ekleme işlemini yapar.
        if coffee.inFavorite == false {
            inFavoriteUpdate(coffee: coffee)
            fetchUpdatedFavorites()
            var currentFavorites = favoriteSubject.value // güncel durum alınır.
            currentFavorites.append(coffee) // yeni gelen veri güncele yollanır.
            print("Favorilere eklendi.")
        } else {
            print("Bu ürün zaten favorilere eklenmiş.")
        }
    }
    
    func inFavoriteUpdate(coffee: Coffee) {
        coffee.inFavorite = true
        do {
            try context.save()
            print("Coffee item in favorite.")
        } catch {
            print("coffee item is not in favorite: \(error)")
        }
    }
    
    func fetchUpdatedFavorites() {
        let fetchRequest: NSFetchRequest<Coffee> = Coffee.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "categoryId", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = NSPredicate(format: "inFavorite == YES", true)
        do {
            let fetchedFavorites = try context.fetch(fetchRequest)
            favoriteSubject.accept(fetchedFavorites)
        } catch {
            print("Fetching favorites failed: \(error)")
        }
    }
    
    func deleteFavoriteItems(index : Int) {
        let fetchRequest: NSFetchRequest<Coffee> = Coffee.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "inFavorite == YES AND coffeeId == \(index)", true)
        do {
            let result = try context.fetch(fetchRequest)
            if let coffeeToDelete = result.first {
                coffeeToDelete.inFavorite = false
                try context.save()
                print("Kahve favorilerden çıkarıldı.")
            } else {
                print("İlgili favorilerde bulunamadı.")
            }
        } catch {
            print("Kahve silme hatası: \(error)")
        }
    }
    
}
