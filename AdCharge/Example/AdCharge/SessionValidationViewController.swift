//
//  SessionValidationViewController.swift
//  AdCharge_Example
//
//  Created by Vorona Vyacheslav on 9/11/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import AdCharge

class SessionValidationViewController: UIViewController {

    public var adCharge: AdCharge?
    public var token: String?

    @IBOutlet weak var sessionIdTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel! {
        didSet {
            resultLabel.text = "We will show the result here..."
        }
    }

    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var activity: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(_ animated: Bool) {
        if let ac = adCharge, let t = token {
            popActivity()
            ac.getSession(authToken: t, sessionId: nil, latitude: nil, longitude: nil) { success, sessions, error in
                if success, !sessions.isEmpty {
                    self.sessionIdTextField.text = sessions[0].sessionId
                    self.checkSession()
                } else {
                    self.hideActivity()
                }
            }
        }
    }

    @IBAction func checkButtonTap(_ sender: Any) {
        checkSession()
    }

    private func checkSession() {
        if let ac = adCharge {
            ac.checkSessionValid(sessionId: self.sessionIdTextField.text!) { success, isValid, error in
                self.hideActivity()
                if success, let valid = isValid {
                    self.resultLabel.text = valid ? "Session is valid" : "Session is not valid"
                } else if let e = error {
                    self.popErrorMessage(error: e)
                } else {
                    let alert = UIAlertController(title: "Woops", message: "Something went wrong...", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }

    private func popActivity() {
        activityView.isHidden = false
        activity.isHidden = false
        activity.startAnimating()
    }

    private func hideActivity() {
        activityView.isHidden = true
        activity.isHidden = true
        activity.stopAnimating()
    }

    private func popErrorMessage(error: AdChargeError) {
        var alertMessage = ""
        var alertTitle = "Error"

        switch error {
        case .apiValidationException(let errorCode, let fields):
            alertMessage = fields.description
            alertTitle += ": \(errorCode)"
        case .apiException(let errorCode):
            alertTitle += ": \(errorCode)"
        case .noConnection:
            alertMessage = "No Internet connection"
        default:
            alertMessage = "Unknown error"
        }

        let alert = UIAlertController(title: "Error", message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
