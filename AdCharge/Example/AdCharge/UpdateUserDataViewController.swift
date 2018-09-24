//
//  UpdateUserDataViewController.swift
//  AdCharge_Example
//
//  Created by Vorona Vyacheslav on 9/3/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import AdCharge

class UpdateUserDataViewController: UIViewController, DatePickerVCDelegate, GenderPickerVCDelegate {

    public var adCharge: AdCharge?
    public var token: String?

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!

    private var birthday: Date? {
        didSet {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            birthdayString = dateFormatter.string(from: birthday!)
        }
    }
    private var birthdayString: String? {
        didSet {
            birthdayLabel.text = birthdayString
        }
    }

    private var gender: AdChargeUserGender? {
        didSet {
            genderLabel.text = gender?.rawValue
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(_ animated: Bool) {
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DatePickerViewController {
            vc.delegate = self
        } else if let vc = segue.destination as? GenderPickerViewController {
            vc.delegate = self
        }
    }

    func dateSelected(date: Date) {
        self.birthday = date
    }

    func genderSelected(gender: AdChargeUserGender) {
        self.gender = gender
    }

    @IBAction func selectBirthdayButtonTap(_ sender: Any) {
        self.performSegue(withIdentifier: "showDatePicker", sender: nil)
    }

    @IBAction func selectGenderButtonTap(_ sender: Any) {
        self.performSegue(withIdentifier: "showGenderPicker", sender: nil)
    }

    @IBAction func updateButtonTap(_ sender: Any) {
        if let t = token {
            var update = UserUpdate()
            if let newUsername = userNameTextField.text, newUsername != "" {
                update.userName = newUsername
            }
            if let newFirstName = firstNameTextField.text, newFirstName != "" {
                update.firstName = newFirstName
            }
            if let newLastName = lastNameTextField.text, newLastName != "" {
                update.lastName = newLastName
            }
            if let newEmail = emailTextField.text, newEmail != "" {
                update.email = newEmail
            }
            if let newPassword = passwordTextField.text, newPassword != "" {
                update.password = newPassword
            }
            if let newBirthday = birthday {
                update.birthday = newBirthday
            }
            if let newGender = gender {
                update.gender = newGender
            }

            adCharge?.updateUserData(authToken: t, userUpdate: update) { success, user, error in

                var alertMessage = ""
                var alertTitle = ""

                if let u = user, let id = u.id, success {
                    alertTitle = "Success"
                    alertMessage = "User with ID:\(id) was successfully updated"
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
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }

    }
}
