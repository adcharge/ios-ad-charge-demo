//
//  InitialViewController.swift
//  AdCharge_Example
//
//  Created by Vorona Vyacheslav on 8/21/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import AdCharge

class InitialViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(_ animated: Bool) {
        if let savedBaseUrl = UserDefaults.standard.string(forKey: "AdChargeBaseUrl"), savedBaseUrl != "" {
            self.performSegue(withIdentifier: "showNavigationViewController", sender: nil)
        } else {
            self.performSegue(withIdentifier: "showBaseUrlEnter", sender: nil)
        }
    }
}
