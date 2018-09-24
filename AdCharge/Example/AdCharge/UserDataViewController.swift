//
//  UserDataViewController.swift
//  AdCharge_Example
//
//  Created by Vorona Vyacheslav on 8/31/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import AdCharge

class UserDataViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    public var adCharge: AdCharge?
    public var token: String?
    private var userData: AdChargeUser?

    @IBOutlet weak var tokenTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tokenTextField.text = token

        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? UpdateUserDataViewController {
            vc.adCharge = self.adCharge
            vc.token = tokenTextField.text
        }
    }

    private func refreshData() {
        if let t = tokenTextField.text {
            adCharge?.getUserData(authToken: t) { success, user, error in
                self.userData = user
                self.tableView.reloadData()
            }
        }
    }

    @IBAction func refreshUserDataButtonTap(_ sender: Any) {
        refreshData()
    }

    @IBAction func updateUserDataButtonTap(_ sender: Any) {
        performSegue(withIdentifier: "showUpdateUserData", sender: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: TableViewCell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell


        if let user = self.userData {
            switch indexPath.row {
            case 0:
                if let bd = user.birthday {
                    cell.cellLabel.text = "Birthday: \(dateToString(date: bd))"
                }
            case 1:
                if let city = user.city {
                    cell.cellLabel.text = "City: \(city)"
                }
            case 2:
                if let country = user.country {
                    cell.cellLabel.text = "Country: \(country)"
                }
            case 3:
                if let dj = user.dateJoined {
                    cell.cellLabel.text = "Date joined: \(dateToString(date: dj))"
                }
            case 4:
                if let deb = user.debet {
                    cell.cellLabel.text = "Debet: \(String(deb))"
                }
            case 5:
                if let email = user.email {
                    cell.cellLabel.text = "Email: \(email)"
                }
            case 6:
                if let firstName = user.firstName {
                    cell.cellLabel.text = "First name: \(firstName)"
                }
            case 7:
                if let lastName = user.lastName {
                    cell.cellLabel.text = "Last name: \(lastName)"
                }
            case 8:
                if let gender = user.gender {
                    cell.cellLabel.text = "Gender: \(gender)"
                }
            case 9:
                if let id = user.id {
                    cell.cellLabel.text = "id: \(id)"
                }
            case 10:
                if let l = user.lat {
                    cell.cellLabel.text = "lat: \(l)"
                }
            case 11:
                if let ln = user.lng {
                    cell.cellLabel.text = "lat: \(ln)"
                }
            case 12:
                if let username = user.username {
                    cell.cellLabel.text = "Username: \(username)"
                }
            case 13:
                if let name = user.name {
                    cell.cellLabel.text = "Name: \(name)"
                }
            case 14:
                if let operatorName = user.operatorName {
                    cell.cellLabel.text = "Operator name: \(operatorName)"
                }
            case 15:
                cell.cellLabel.text = "Interests [WIP]"
            default:
                print("How did we get here?")
            }
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

    func dateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
}


