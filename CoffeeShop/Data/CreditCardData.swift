//
//  CreditCardData.swift
//  CoffeeShop
//
//  Created by Mehmet Gül on 31.08.2023.
//

import Foundation

class CreditCardData {
    
    struct CreditCardData {
        var creditCardId : Int16
        var creditCardName : String
        var creditCardBalance : Int16
        var firstCreditCardNumber : Int16
        var secondCreditCardNumber : Int16
        var thirdCreditCardNumber : Int16
        var fourthCreditCardNumber : Int16
        var creditCardExpirationDate : Int16
        var creditCardCVV : Int16
    }
    
    lazy var creditCards: [CreditCardData] = [
        CreditCardData(creditCardId: 1, creditCardName: "Ziraat", creditCardBalance: 200, firstCreditCardNumber: 1234, secondCreditCardNumber: 1234, thirdCreditCardNumber: 1234, fourthCreditCardNumber: 1234, creditCardExpirationDate: 1223, creditCardCVV: 123),
        CreditCardData(creditCardId: 2, creditCardName: "YapıKredi", creditCardBalance: 300, firstCreditCardNumber: 5678, secondCreditCardNumber: 5678, thirdCreditCardNumber: 5678, fourthCreditCardNumber: 5678, creditCardExpirationDate: 1224, creditCardCVV: 456),
        CreditCardData(creditCardId: 3, creditCardName: "Akbank", creditCardBalance: 400, firstCreditCardNumber: 7890, secondCreditCardNumber: 7890, thirdCreditCardNumber: 7890, fourthCreditCardNumber: 7890, creditCardExpirationDate: 1225, creditCardCVV: 789)
    ]
    
}
