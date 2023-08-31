//
//  ViewController.swift
//  CoffeeShop
//
//  Created by Mehmet Gül on 14.08.2023.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet weak var getStartedButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getStartedButton.layer.cornerRadius = 16
        
    }

    @IBAction func getStartedClicked(_ sender: Any) {
        // HomeViewController'a geçiş:
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let homeVC = storyboard.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController {
            homeVC.modalPresentationStyle = .fullScreen
            self.present(homeVC, animated: true, completion: nil)
        }
        
    }
    
}

