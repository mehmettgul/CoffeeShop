//
//  BottomSheetViewController.swift
//  CoffeeShop
//
//  Created by Mehmet Gül on 1.09.2023.
//

import UIKit

protocol BottomSheetViewControllerDelegate : AnyObject {
    func reloadData()
}

class BottomSheetViewController: UIViewController {
    
    @IBOutlet weak var addressTitleText: UITextField!
    @IBOutlet weak var addressText: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    var delegate : BottomSheetViewControllerDelegate?
    
    var viewmodel = BottomSheetViewmodel()
    var selectedIndex = 0
    var bottomSheetAddress : [Address] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.layer.cornerRadius = 16
        editButton.layer.cornerRadius = 16
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        let addressTitle = addressTitleText.text ?? ""
        let address = addressText.text ?? ""
        viewmodel.addAddress(address: address, addressTitle: addressTitle)
        self.dismiss(animated: true, completion: {  // presentda life cycle yok.
            self.delegate?.reloadData()
        })
    }
    
    @IBAction func editButtonClicked(_ sender: Any) {
        if selectedIndex >= 0 {
            let addressTitle = addressTitleText.text ?? ""
            let address = addressText.text ?? ""
            viewmodel.editAddress(addressId: bottomSheetAddress[selectedIndex].addressId!, address: address, addressTitle: addressTitle)
            self.dismiss(animated: true, completion: {
                self.delegate?.reloadData()
            })
        } else {
            let alertController = UIAlertController(title: "Düzenlenecek bir adres yok.", message: "Lütfen bir adres seçin.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Tamam", style: .default) { (action:UIAlertAction) in
                // Kullanıcı "Tamam" düğmesine tıkladığında yapılacak işlemler buraya gelir.
            }
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
