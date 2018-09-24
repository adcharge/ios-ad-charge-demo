//
//  RegistrationConfirmViewController.swift
//  AdCharge_Example
//
//  Created by Vorona Vyacheslav on 8/24/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import AdCharge

class RegistrationConfirmViewController: UIViewController {

    public weak var adCharge: AdCharge?
    public var userId: Int?

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = "Confirm Registration"
        }
    }

    @IBOutlet weak var confirmationCodeTextField: UITextField! {
        didSet {
            confirmationCodeTextField.placeholder = "Confirmation code"
        }
    }

    @IBOutlet weak var confirmButton: UIButton! {
        didSet {
            confirmButton.setTitle("Confirm", for: .normal)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func confirmButtonTap(_ sender: Any) {
        var alertMessage = ""
        var alertTitle = ""

        if let uId = self.userId, let code = confirmationCodeTextField.text {

            self.adCharge?.registrationConfirm(userId: uId, code: code) { success, error in

                if success {
                    alertTitle = "Success"
                    alertMessage = "Registration of user with ID:\(uId) was successfully confirmed"
                } else {
                    alertTitle = "Error"
                    switch error {
                    case .apiValidationException(let errorCode, let fields)?:
                        alertMessage = fields.description
                        alertTitle += ": \(errorCode)"
                    case .apiException(let errorCode)?:
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
                                                if let nc = self.navigationController {
                                                    let viewControllers: [UIViewController] = nc.viewControllers
                                                    for aViewController in viewControllers {
                                                        if aViewController is LoginViewController {
                                                            nc.popToViewController(aViewController, animated: true)
                                                        }
                                                    }
                                                }
                                              }) : nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            alertTitle = "Error"
            alertMessage = "Wow, userId disappeared! Now it got really strange..."
            let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

