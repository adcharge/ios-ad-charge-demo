//
//  LoginViewController.swift
//  AdCharge_Example
//
//  Created by Vorona Vyacheslav on 8/17/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import AdCharge

class LoginViewController: UIViewController {

    private var adCharge: AdCharge?
    private var token: String?

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = "Log in"
        }
    }

    @IBOutlet weak var userNameTextField: UITextField! {
        didSet {
            userNameTextField.placeholder = "User Name"
        }
    }

    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.placeholder = "Password"
        }
    }

    @IBOutlet weak var individualKeyTextField: UITextField! {
        didSet {
            individualKeyTextField.placeholder = "Individual Key"
        }
    }

    @IBOutlet weak var loginButton: UIButton! {
        didSet {
            loginButton.setTitle("Log In", for: .normal)
        }
    }

    @IBOutlet weak var registerButton: UIButton! {
        didSet {
            registerButton.setTitle("Register", for: .normal)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let baseUrlString = UserDefaults.standard.string(forKey: "AdChargeBaseUrl"), baseUrlString != "",
            let baseUrl = URL(string: baseUrlString) {

            adCharge = AdCharge(baseUrl: baseUrl)
        } else {
            fatalError("Error - Loading LoginViewController without appropriate baseUrl in UserDefaults")
        }

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let nc = self.navigationController, let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == nc.navigationBar.frame.height + 20 {
                self.view.frame.origin.y -= 100
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if let nc = self.navigationController, let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != nc.navigationBar.frame.height + 20 {
                self.view.frame.origin.y += 100
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? RegisterViewController {
            vc.adCharge = self.adCharge
        } else if let vc = segue.destination as? MenuViewController {
            vc.token = self.token
            vc.adCharge = self.adCharge
        }
    }

    @IBAction func loginButtonTap(_ sender: Any) {
        view.endEditing(true)

        self.adCharge?.login(userName: userNameTextField.text!, password: passwordTextField.text!, individualKey: individualKeyTextField.text!) { success, token, error in

            if let t = token, t != "", success {
                self.token = t
                self.performSegue(withIdentifier: "showSession", sender: nil)
            } else {
                var alertMessage = ""
                var alertTitle = "Error"

                switch error {
                case .apiValidationException(let errorCode, let fields)?:
                    alertMessage = fields.description
                    alertTitle += ": \(errorCode)"
                case .noConnection?:
                    alertMessage = "No Internet connection"
                default:
                    alertMessage = "Unknown error"
                }

                let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    @IBAction func registerButtonTap(_ sender: Any) {
        view.endEditing(true)
        self.performSegue(withIdentifier: "showRegister", sender: nil)
    }
}
