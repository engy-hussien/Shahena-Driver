//
//  PhoneListViewController.swift
//  MandobiDriver
//
//  Created by ِAmr on 3/8/17.
//  Copyright © 2017 Applexicon. All rights reserved.
//

import UIKit

class PhoneListViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {

    @IBOutlet weak var phoneListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneListTableView.delegate = self
        phoneListTableView.dataSource = self

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "phoneItem", for: indexPath) as! PhoneListTableViewCell
        
        cell.title.text = indexPath.row == 0 ? LanguageHelper.getStringLocalized("client_phone") : LanguageHelper.getStringLocalized("receiver_phone")
        
        cell.phone.text = indexPath.row == 0 ? MainContainerViewController.driver.getOrder().getClientPhone() : MainContainerViewController.driver.getOrder().getReceiverPhone()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true, completion: nil)
        let url = URL(string: "telprompt://\(indexPath.row == 0 ? MainContainerViewController.driver.getOrder().getClientPhone() : MainContainerViewController.driver.getOrder().getReceiverPhone())")!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }

}
