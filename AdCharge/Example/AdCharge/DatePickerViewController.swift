//
//  DatePickerViewController.swift
//  AdCharge_Example
//
//  Created by Vorona Vyacheslav on 9/4/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

public protocol DatePickerVCDelegate {
    func dateSelected(date: Date)
}

class DatePickerViewController: UIViewController {

    public var delegate: DatePickerVCDelegate?

    @IBOutlet weak var datePicker: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.datePicker.maximumDate = Date()
    }

    override func viewDidAppear(_ animated: Bool) {

    }

    @IBAction func doneButtonTap(_ sender: Any) {
        if let d = delegate {
            d.dateSelected(date: datePicker.date)
        }
        self.dismiss(animated: true, completion: nil)
    }
}
