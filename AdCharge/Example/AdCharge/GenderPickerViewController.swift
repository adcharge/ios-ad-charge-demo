//
//  GenderPickerViewController.swift
//  AdCharge_Example
//
//  Created by Vorona Vyacheslav on 9/4/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import AdCharge

public protocol GenderPickerVCDelegate {
    func genderSelected(gender: AdChargeUserGender)
}

class GenderPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var genderPicker: UIPickerView!
    
    public var delegate: GenderPickerVCDelegate?
    private var selectedGender: AdChargeUserGender?


    override func viewDidLoad() {
        super.viewDidLoad()
        genderPicker.delegate = self
        genderPicker.dataSource = self
    }

    override func viewDidAppear(_ animated: Bool) {

    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch row {
        case 0:
            return AdChargeUserGender.male.rawValue
        case 1:
            return AdChargeUserGender.female.rawValue
        case 2:
            return AdChargeUserGender.undefined.rawValue
        default:
            return ""
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row {
        case 0:
            selectedGender = .male
        case 1:
            selectedGender = .female
        case 2:
            selectedGender = .undefined
        default:
            selectedGender = nil
        }
    }

    @IBAction func doneButtonTap(_ sender: Any) {
        if let d = delegate, let sg = selectedGender {
            d.genderSelected(gender: sg)
        }
        self.dismiss(animated: true, completion: nil)
    }
}
