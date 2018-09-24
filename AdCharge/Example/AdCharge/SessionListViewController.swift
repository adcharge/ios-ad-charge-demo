//
//  SessionListViewController.swift
//  AdCharge_Example
//
//  Created by Vorona Vyacheslav on 9/7/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import AdCharge

class SessionListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    public var adCharge: AdCharge?
    public var token: String?

    private var selectedSessionId: String?

    private var sessions: [AdChargeSession] = []

    @IBOutlet weak var tokenTextField: UITextField!
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tokenTextField.text = token

        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(UINib(nibName: "SessionCell", bundle: nil), forCellReuseIdentifier: "SessionCell")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ImagesViewController {
            vc.adCharge = self.adCharge
            vc.token = tokenTextField.text
            vc.sessionId = selectedSessionId
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sessions.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "SessionCell", for: indexPath) as! SessionCell

        let session = sessions[indexPath.row]
        cell.topLabel.text = "sessionId:\n \(session.sessionId)"
        cell.middleLabel.text = "expires:\n \(session.expires)"
        cell.bottomLabel.text = "url:\n \(session.url)"

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSessionId = sessions[indexPath.row].sessionId
        performSegue(withIdentifier: "showImages", sender: nil)
    }

    @IBAction func getSessionButtonTap(_ sender: Any) {
        if let ac = self.adCharge, let t = tokenTextField.text {
            ac.getSession(authToken: t, sessionId: nil, latitude: Double(latitudeTextField.text!), longitude: Double(longitudeTextField.text!)) { success, sessions, error in
                if success, !sessions.isEmpty {
                    self.sessions = sessions
                    self.tableView.reloadData()
                    return
                }

                var alertMessage = ""
                var alertTitle = "Error"

                if success, sessions.count == 0 {
                    alertTitle = "No active sessions"
                    alertMessage = "No sessions were returned by API"
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
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
