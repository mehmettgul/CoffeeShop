//
//  PaymentViewController.swift
//  CoffeeShop
//
//  Created by Mehmet Gül on 15.08.2023.
//

import UIKit
class PaymentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, BottomSheetViewControllerDelegate {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var confirmAndFinishButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var creditCardTableView: UITableView!
    
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var cardExpirationDateLabel: UILabel!
    @IBOutlet weak var cardCVVLabel: UILabel!
    
    @IBOutlet weak var addressTitle: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressScrollView: UIScrollView!
    @IBOutlet weak var addressView: UIView!
    
    var viewmodel = PaymentViewmodel()
    var cartViewmodel = CartViewmodel()
    
    var cards : [CreditCard] = []
    var cartItems : [Coffee] = []
    var addresses : [Address] = []
    
    var totalPayment = 0
    var selectedButtonIndex: Int?
    var selectedCardIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        creditCardTableView.delegate = self
        creditCardTableView.dataSource = self
        if let firstButton = addressView.subviews.first as? UIButton {
            firstButton.backgroundColor = .white
        }
        if let address = viewmodel.fetchAddresses() {
            addresses = address
            setAddressButton()
        }
        addressTitle.text = addresses.first?.addressTitle
        addressLabel.text = addresses.first?.address
        configureButtons()
        amountLabel.text = "\(totalPayment) ₺"
        cards = viewmodel.fetchCreditCards()!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // ScrollView'daki en son seçilen butonun okunması
        if let savedButton = UserDefaults.standard.value(forKey: "SelectedButton") as? Int {
            selectedButtonIndex = savedButton
        }
        // ScrollView'daki seçili butonu ayarla
        if let selectedButtonIndex = selectedButtonIndex,
            let selectedButton = addressView.viewWithTag(selectedButtonIndex) as? UIButton {
            addressButtonTapped(selectedButton)
        }
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func reloadData() {
        if let address = viewmodel.fetchAddresses() {
            addresses = address
        }
        addressTitle.text = addresses[selectedButtonIndex!].addressTitle
        addressLabel.text = addresses[selectedButtonIndex!].address
        setAddressButton()
    }
    
    @IBAction func deleteButtonClicked(_ sender: Any) {
        if var selectedButtonIndex = selectedButtonIndex {
            let selectedAddress = addresses[selectedButtonIndex]
            viewmodel.deleteAddress(addressId: selectedAddress.addressId!)
            addresses.remove(at: selectedButtonIndex)
            setAddressButton()
            selectedButtonIndex = 0
            addressTitle.text = addresses.first?.addressTitle
            addressLabel.text = addresses.first?.address
            UserDefaults.standard.removeObject(forKey: "SelectedButton")
        }
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let editAndAddVC = storyboard.instantiateViewController(withIdentifier: "BottomSheetViewController") as? BottomSheetViewController {
            editAndAddVC.bottomSheetAddress = addresses
            editAndAddVC.modalPresentationStyle = .formSheet
            editAndAddVC.delegate = self
            self.present(editAndAddVC, animated: true, completion: nil)
        }
    }
    @IBAction func editButtonClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let editAndAddVC = storyboard.instantiateViewController(withIdentifier: "BottomSheetViewController") as? BottomSheetViewController {
            editAndAddVC.modalPresentationStyle = .formSheet
            if selectedButtonIndex != nil {
                editAndAddVC.selectedIndex = selectedButtonIndex!
            } else {
                showPopup(title: "Düzenlenecek bir adres yok.", message: "Lütfen bir adres seçin." )
            }
            editAndAddVC.bottomSheetAddress = addresses
            editAndAddVC.delegate = self
            self.present(editAndAddVC, animated: true, completion: nil)
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // kaç bölüm olacağı
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count // her bölümde kaç satır olacağı
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "creditCardCell")!
        cell.textLabel?.text = cards[indexPath.row].creditCardName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for cell in tableView.visibleCells {
            cell.backgroundColor = UIColor.white
        }
        selectedCardIndex = indexPath.row
        let selectedCell = tableView.cellForRow(at: indexPath)
        selectedCell?.backgroundColor = .systemBrown
        tableView.deselectRow(at: indexPath, animated: true)
        self.cardNameLabel.text = cards[indexPath.row].creditCardName
        self.cardNumberLabel.text = "\(cards[indexPath.row].firstCreditCardNumber) \(cards[indexPath.row].secondCreditCardNumber) \(cards[indexPath.row].thirdCreditCardNumber) \(cards[indexPath.row].fourthCreditCardNumber)"
        self.cardExpirationDateLabel.text = "\(cards[indexPath.row].creditCardExpirationDate)"
        self.cardCVVLabel.text = "\(cards[indexPath.row].creditCardCVV)"
    }
    
    @IBAction func confirmAndFinishButtonTapped(_ sender: Any) {
        if !cartItems.isEmpty {
            if selectedButtonIndex != nil && selectedCardIndex != nil {
                var creditCardBalance = cards[selectedCardIndex!].creditCardBalance
                if creditCardBalance > totalPayment {
                    creditCardBalance = creditCardBalance - Int16(totalPayment)
                    viewmodel.saveCreditCardBalance(creditCardId: cards[selectedCardIndex!].creditCardId, creditCardBalance: creditCardBalance)
                    cartViewmodel.updateCartItemsAfterDelivery(coffees: cartItems)
                } else {
                    showPopup(title: "Bakiyeniz yetersiz.", message: "Başka bir kart seçin. (Bakiye : \(creditCardBalance))")
                }
            } else {
                showPopup(title: "Lütfen bir adres seçin.", message: "Eğer seçecek bir adresiniz yoksa bir adres ekleyin.")
            }
        } else {
            showPopup(title: "Sepetiniz boş.", message: "Sipariş vermek için sepetinize bir kahve ekleyin.")
        }
        showPopup(title: "Siparişiniz alındı.", message: "Afiyet olsun.")
        amountLabel.text = "0₺"
    }
    
    func showPopup(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Tamam", style: .default) { (action:UIAlertAction) in
            // Kullanıcı "Tamam" düğmesine tıkladığında yapılacak işlemler buraya gelir.
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func configureButtons() {
        editButton.layer.cornerRadius = 16
        addButton.layer.cornerRadius = 16
        confirmAndFinishButton.layer.cornerRadius = 16
        deleteButton.layer.cornerRadius = 16
    }
    
    @objc func addressButtonTapped(_ sender: UIButton) {
        if let index = sender.tag as? Int {
            selectedButtonIndex = index
            UserDefaults.standard.set(index, forKey: "SelectedButton") // Kullanıcının son seçtiği adresi tutuyoruz.
            updateButtonColors()
            if let address = addresses.first(where: { $0.addressTitle == sender.title(for: .normal) }) {
                addressTitle.text = address.addressTitle
                addressLabel.text = address.address
            }
        }
    }
       
    func updateButtonColors() {
        for subview in addressView.subviews {
            if let button = subview as? UIButton {
                button.backgroundColor = (button.tag == selectedButtonIndex) ? .systemBrown : .white
            }
        }
    }
       
    func setAddressButton() {
        for subview in addressView.subviews {
            subview.removeFromSuperview()
        }
           
        let buttonWidth: CGFloat = 120
        let buttonHeight: CGFloat = 40
           
        var xOffset: CGFloat = 10
        let yOffset: CGFloat = (addressView.frame.height - buttonHeight) / 2
           
        if addresses.isEmpty {
            addressTitle.text = "Lütfen bir adres ekleyiniz."
            addressLabel.text = ""
        } else {
            selectedButtonIndex = selectedButtonIndex ?? 0
        }
           
        for (index, address) in addresses.enumerated() {
            let button = UIButton(type: .custom)
            button.setTitle(address.addressTitle, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = (index == selectedButtonIndex) ? .systemBrown : .white
            button.sizeToFit()
            button.layer.cornerRadius = 12
            button.tag = index
            button.addTarget(self, action: #selector(addressButtonTapped(_:)), for: .touchUpInside)
            button.frame = CGRect(x: xOffset, y: yOffset, width: buttonWidth, height: buttonHeight)
            addressView.addSubview(button)
            xOffset += buttonWidth + 10
        }
           
        addressScrollView.backgroundColor = .white
        addressView.frame.size.width = xOffset
        addressScrollView.contentSize = CGSize(width: addressView.frame.width, height: addressScrollView.frame.height)
        addressScrollView.isDirectionalLockEnabled = true
        addressScrollView.isScrollEnabled = true
        
        updateButtonColors() // Buton renklerini güncelliyoruz
    }
}
    
