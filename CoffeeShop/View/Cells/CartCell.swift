import UIKit

protocol CartCellDelegate: AnyObject {
    func deleteCell(_ cell: UICollectionViewCell)
    func reloadCollectionView()
}

class CartCell: UICollectionViewCell {

    @IBOutlet weak var coffeeImage: UIImageView!
    @IBOutlet weak var coffeeName: UILabel!
    @IBOutlet weak var coffeePrice: UILabel!
    @IBOutlet weak var numberOfCoffees: UILabel!
    weak var delegate: CartCellDelegate?
    
    var viewmodel = CartViewmodel()
    var numberOfCoffee : Int16 = 1
    var coffeeId : Int16 = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func didMoveToWindow() {
        numberOfCoffees.text = "\(numberOfCoffee)"
    }
    
    func setCell(coffee: Coffee){
        self.coffeeId = coffee.coffeeId
        if self.coffeeId == coffee.coffeeId {
            self.numberOfCoffee = coffee.numberOfCoffee
        }
        self.coffeeImage.image = UIImage(named: "exampleCoffee")
        self.coffeeName.text = coffee.name
        self.coffeePrice.text = "\(coffee.price) ₺"
    }
    
    @IBAction func reduceButtonClicked(_ sender: Any) { // küçültme
        if numberOfCoffee > 1 {
            numberOfCoffee -= 1
            viewmodel.numberOfCartCoffee(coffeeId: coffeeId, numberOfCoffee: numberOfCoffee)
            numberOfCoffees.text = "\(numberOfCoffee)"
            delegate?.reloadCollectionView()
        } else {
            viewmodel.numberOfCartCoffee(coffeeId: coffeeId, numberOfCoffee: 1)
            delegate?.reloadCollectionView()
            delegate?.deleteCell(self)
        }
    }
    
    @IBAction func increaseButtonClicked(_ sender: Any) { // büyültme
        if numberOfCoffee < 10 {
            numberOfCoffee += 1
            viewmodel.numberOfCartCoffee(coffeeId: coffeeId, numberOfCoffee: numberOfCoffee)
            delegate?.reloadCollectionView()
            numberOfCoffees.text = "\(numberOfCoffee)"
        } else {
            viewmodel.numberOfCartCoffee(coffeeId: coffeeId, numberOfCoffee: numberOfCoffee)
            delegate?.reloadCollectionView()
            numberOfCoffees.text = "\(numberOfCoffee)"
        }
    }
    
    @IBAction func deleteButtonClicked(_ sender: Any) {
        viewmodel.numberOfCartCoffee(coffeeId: coffeeId, numberOfCoffee: 1)
        delegate?.reloadCollectionView()
        delegate?.deleteCell(self)
    }
}
