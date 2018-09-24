//
//  RegisterViewController.swift
//  AdCharge_Example
//
//  Created by Vorona Vyacheslav on 8/17/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import AdCharge

class RegisterViewController: UIViewController {

    public weak var adCharge: AdCharge?
    private var registeredUserId: Int?

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = "Create Operator"
        }
    }

    @IBOutlet weak var userNameTextField: UITextField! {
        didSet {
            userNameTextField.placeholder = "Username"
        }
    }

    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.placeholder = "Password"
        }
    }

//    @IBOutlet weak var confirmPasswordTextField: UITextField! {
//        didSet {
//            confirmPasswordTextField.placeholder = "Confirm Password"
//        }
//    }

    @IBOutlet weak var individualKeyTextField: UITextField! {
        didSet {
            individualKeyTextField.placeholder = "Individual Key"
        }
    }

    @IBOutlet weak var registerButton: UIButton! {
        didSet {
            registerButton.setTitle("Register", for: .normal)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let nc = self.navigationController, ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y == nc.navigationBar.frame.height + 20 {
                self.view.frame.origin.y -= 100
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if let nc = self.navigationController, ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y != nc.navigationBar.frame.height + 20 {
                self.view.frame.origin.y += 100
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is RegistrationConfirmViewController {
            if let vc = segue.destination as? RegistrationConfirmViewController {
                vc.adCharge = self.adCharge
                vc.userId = registeredUserId
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func registerButtonTap(_ sender: Any) {
        view.endEditing(true)

        self.adCharge?.registerUser(userName: userNameTextField.text!, password: passwordTextField.text!, individualKey: individualKeyTextField.text!) { success, userId, error in

            var alertMessage = ""
            var alertTitle = ""

            if let id = userId, success {
                self.registeredUserId = id
                alertTitle = "Success"
                alertMessage = "User with ID:\(id) was successfully created"
            } else {
                alertTitle = "Error"

                switch error {
                case .apiValidationException(let errorCode, let fields)?:
                    alertMessage = fields.description
                    alertTitle += ": \(errorCode)"
                case .noConnection?:
                    alertMessage = "No Internet connection"
                default:
                    alertMessage = "Unknown error"
                }
            }

            let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default,
                                          handler: success ? ({(alert: UIAlertAction!) in
                                            self.performSegue(withIdentifier: "showConfirmRegister", sender: nil)
                                          }) : nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
