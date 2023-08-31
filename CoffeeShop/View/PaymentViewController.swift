//
//  PaymentViewController.swift
//  CoffeeShop
//
//  Created by Mehmet Gül on 15.08.2023.
//

import UIKit

class PaymentViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var confirmAndFinishButton: UIButton!
    @IBOutlet weak var amountLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        addButton.layer.cornerRadius = 16
        editButton.layer.cornerRadius = 16
        confirmAndFinishButton.layer.cornerRadius = 16
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
