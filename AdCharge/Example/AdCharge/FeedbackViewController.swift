//
//  FeedbackViewController.swift
//  AdCharge_Example
//
//  Created by Vorona Vyacheslav on 9/11/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import AdCharge

public protocol FeedbackPickerVCDelegate {
    func feedbackSelected(feedback: AdChargeFeedback)
}

class FeedbackPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var feedbackPicker: UIPickerView!

    public var delegate: FeedbackPickerVCDelegate?
    private var selectedFeedback: AdChargeFeedback = .noPress


    override func viewDidLoad() {
        super.viewDidLoad()
        feedbackPicker.delegate = self
        feedbackPicker.dataSource = self
    }

    override func viewDidAppear(_ animated: Bool) {

    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 4
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch row {
        case 0:
            return AdChargeFeedback.noPress.rawValue
        case 1:
            return AdChargeFeedback.like.rawValue
        case 2:
            return AdChargeFeedback.dislike.rawValue
        case 3:
            return AdChargeFeedback.hideBanner.rawValue
        default:
            return ""
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        switch row {
        case 0:
            selectedFeedback = .noPress
        case 1:
            selectedFeedback = .like
        case 2:
            selectedFeedback = .dislike
        case 3:
            selectedFeedback = .hideBanner
        default:
            break
        }
    }

    @IBAction func doneButtonTap(_ sender: Any) {
        if let d = delegate {
            d.feedbackSelected(feedback: selectedFeedback)
        }
        self.dismiss(animated: true, completion: nil)
    }
}
