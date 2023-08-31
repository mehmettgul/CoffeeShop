//
//  SearchViewmodel.swift
//  CoffeeShop
//
//  Created by Mehmet Gül on 25.08.2023.
//

import Foundation
import RxSwift
import RxCocoa
import CoreData
import UIKit

class SearchViewmodel {
    
    var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
        
    func searchCoffees(searchText: String) -> Observable<[Coffee]> {
        return Observable.create { observer in
            var coffees: [Coffee] = []
            
            let fetchRequest: NSFetchRequest<Coffee> = Coffee.fetchRequest()
            let sortDescriptor = NSSortDescriptor(key: "coffeeId", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            if !searchText.isEmpty {
                fetchRequest.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchText) // name içerenleri büyük küçük harf ayrımı olmaksızın alır.
            }
            do {
                coffees = try self.context.fetch(fetchRequest)
                observer.onNext(coffees) // Kahve dizisini yayınla
                observer.onCompleted() // İşlem tamamlandığında onComplete çağrısı yapılır işlem tamam diyoruz.
            } catch {
                observer.onError(error) // Hata olursa onError ile yayınla bu durumu
            }
            
            return Disposables.create() // observable ile işimiz bitince observable'ı temizler
        }
    }
    
}
