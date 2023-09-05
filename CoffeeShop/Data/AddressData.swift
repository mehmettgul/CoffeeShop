//
//  AddressData.swift
//  CoffeeShop
//
//  Created by Mehmet Gül on 31.08.2023.
//

import Foundation

class AddressData {
    
    struct AddressData {
        var addressId : UUID
        var address : String
        var addressTitle : String
    }
    
    lazy var addresses: [AddressData] = [
        AddressData(addressId: UUID(), address: "asdasd", addressTitle: "ev"),
        AddressData(addressId: UUID(), address: "zxczxc", addressTitle: "iş"),
        AddressData(addressId: UUID(), address: "klşklş", addressTitle: "apart"),
        AddressData(addressId: UUID(), address: "möçmçö", addressTitle: "okul")
    ]
    
}
