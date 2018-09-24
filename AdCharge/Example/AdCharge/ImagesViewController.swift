//
//  ImagesViewController.swift
//  AdCharge_Example
//
//  Created by Vorona Vyacheslav on 9/7/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import AdCharge

class ImagesViewController: UIViewController, FeedbackPickerVCDelegate {

    var adCharge: AdCharge?
    var token: String?
    var sessionId: String?

    @IBOutlet weak var smallImageView: UIImageView!
    @IBOutlet weak var largeImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(_ animated: Bool) {
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? FeedbackPickerViewController {
            vc.delegate = self
        }
    }

    @IBAction func smallButtonTap(_ sender: Any) {
        if let ac = adCharge, let t = token, let sId = sessionId {
            ac.getAdvertisementImage(authToken: t, sessionId: sId, imagePolicy: .small) { success, images, error in

                if success, !images.isEmpty {
                    self.smallImageView.image = images[0]
                    self.largeImageView.image = nil
                } else if let e = error {
                    self.popErrorMessage(error: e)
                }
            }
        }
    }

    @IBAction func largeButtonTap(_ sender: Any) {
        if let ac = adCharge, let t = token, let sId = sessionId {
            ac.getAdvertisementImage(authToken: t, sessionId: sId, imagePolicy: .large) { success, images, error in

                if success, !images.isEmpty {
                    self.smallImageView.image = nil
                    self.largeImageView.image = images[0]
                } else if let e = error {
                    self.popErrorMessage(error: e)
                }
            }
        }
    }
    
    @IBAction func bothButtonTap(_ sender: Any) {
        if let ac = adCharge, let t = token, let sId = sessionId {
            ac.getAdvertisementImage(authToken: t, sessionId: sId, imagePolicy: .both) { success, images, error in

                if success, images.count == 2 {
                    self.smallImageView.image = images[0]
                    self.largeImageView.image = images[1]
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

    @IBAction func sendFeedbackButtonTap(_ sender: Any) {
        performSegue(withIdentifier: "showFeedbackPicker", sender: nil)
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

    public func feedbackSelected(feedback: AdChargeFeedback) {
        if let ac = adCharge, let t = token, let sId = sessionId {
            ac.sendSessionFeedback(authToken: t, sessionId: sId, feedback: feedback) { success, error in
                if success {
                    let alert = UIAlertController(title: "Success", message: "Feedback successfully sent", preferredStyle: UIAlertControllerStyle.alert)
//                    alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in
//                        self.navigationController?.popViewController(animated: true)
//                    }))
                    alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else if let e = error {
                    self.popErrorMessage(error: e)
                }
            }
        }
    }
}
