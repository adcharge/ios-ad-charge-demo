//
//  BaseUrlEnterViewController.swift
//  AdCharge_Example
//
//  Created by Vorona Vyacheslav on 8/21/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class BaseUrlEnterViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = "Enter Base URL"
        }
    }

    @IBOutlet weak var baseUrlTextField: UITextField! {
        didSet {
            baseUrlTextField.placeholder = "Base URL"
        }
    }

    @IBOutlet weak var enterButton: UIButton! {
        didSet {
            enterButton.setTitle("Enter", for: .normal)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func enterButtonTap(_ sender: Any) {
        if baseUrlTextField.text != "" {
            UserDefaults.standard.set(baseUrlTextField.text, forKey: "AdChargeBaseUrl")
            performSegue(withIdentifier: "showNavigationViewController", sender: nil)
        }
    }
}
