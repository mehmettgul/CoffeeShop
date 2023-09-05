//
//  CartViewController.swift
//  CoffeeShop
//
//  Created by Mehmet Gül on 14.08.2023.
//

import UIKit
import RxSwift
import RxCocoa

class CartViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CartCellDelegate {
    
    @IBOutlet weak var cartCollectionView: UICollectionView!
    @IBOutlet weak var payAmountLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    
    var viewModel = CartViewmodel()
    private let disposeBag = DisposeBag()
    var cart: [Coffee] = []
    var totalPayment = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cartCollectionView.delegate = self
        cartCollectionView.dataSource = self
        setCollectionView()
        bindToViewModel()
        confirmButton.layer.cornerRadius = 16
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchUpdatedCart()
        reloadCollectionView()
    }
    
    func deleteCell(_ cell: UICollectionViewCell) {
        if let indexPath = cartCollectionView.indexPath(for: cell) {
            viewModel.deleteCartItems(coffeeId: cart[indexPath.row].coffeeId)
            cart.remove(at: indexPath.item)
            cartCollectionView.deleteItems(at: [indexPath])
            cartCollectionView.reloadData()
            reloadCollectionView() 
        }
    }
    
    func reloadCollectionView() {
        payAmountLabel.text = "\(calculateTotalPayment()) ₺"
    }
    
    func calculateTotalPayment() -> Int {
        totalPayment = 0
        if cart.isEmpty {
            totalPayment = 0
            return totalPayment
        } else {
            for item in cart {
                totalPayment += Int(item.price * item.numberOfCoffee)
            }
            return totalPayment
        }
    }
    
    private func bindToViewModel() {
        viewModel.cartObservable
            .subscribe(onNext: { [weak self] cartItem in
                self?.cart = cartItem
                self?.cartCollectionView.reloadData()
            }).disposed(by: disposeBag)
    }
    
    @IBAction func confirmButtonClicked(_ sender: Any) {
        // PaymentViewController'a geçiş:
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let paymentVC = storyboard.instantiateViewController(withIdentifier: "PaymentViewController") as? PaymentViewController {
            paymentVC.totalPayment = calculateTotalPayment()
            paymentVC.cartItems = cart
            paymentVC.modalPresentationStyle = .fullScreen
            self.present(paymentVC, animated: true, completion: nil)
        }
    }
    
    func setCollectionView() {
        cartCollectionView.register(UINib(nibName: "CartCell", bundle: nil), forCellWithReuseIdentifier: "cartCell")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        layout.minimumInteritemSpacing = 20
        cartCollectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cart.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cartCell", for: indexPath) as? CartCell else { return UICollectionViewCell() }
        cell.delegate = self
        cell.setCell(coffee: cart[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let cellWidth = screenWidth - 10
        let cellHeight: CGFloat = 165
            
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
}
