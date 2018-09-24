//
//  MenuViewController.swift
//  AdCharge_Example
//
//  Created by Vorona Vyacheslav on 8/28/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import AdCharge

class MenuViewController: UIViewController {

    public var adCharge: AdCharge?
    public var token: String?

    @IBOutlet weak var userDataButton: UIButton! {
        didSet {
            userDataButton.setTitle("User Data", for: .normal)
        }
    }

    @IBOutlet weak var sessionListButton: UIButton! {
        didSet {
            sessionListButton.setTitle("Sessions", for: .normal)
        }
    }

    @IBOutlet weak var sessionValidationButton: UIButton! {
        didSet {
            sessionValidationButton.setTitle("Session Validation", for: .normal)
        }
    }

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            if let t = token {
                titleLabel.text = "Session\n \(t)"
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
            if let titleL = titleLabel, let t = token {
                titleL.text = "Token\n \(t)"
            }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? UserDataViewController {
            vc.adCharge = self.adCharge
            vc.token = self.token
        } else if let vc = segue.destination as? SessionListViewController {
            vc.adCharge = self.adCharge
            vc.token = self.token
        } else if let vc = segue.destination as? SessionValidationViewController {
            vc.adCharge = self.adCharge
            vc.token = self.token
        }
    }

    @IBAction func userDataButtonTap(_ sender: Any) {
        self.performSegue(withIdentifier: "showUserData", sender: nil)
    }

    @IBAction func sessionListButtonTap(_ sender: Any) {
        performSegue(withIdentifier: "showSessionList", sender: nil)
    }

    @IBAction func sessionValidationButtonTap(_ sender: Any) {
        performSegue(withIdentifier: "showValidation", sender: nil)
    }
}
