//
//  ProfileViewController.swift
//  MandobiDriver
//
//  Created by ِAmr on 1/24/17.
//  Copyright © 2017 Applexicon. All rights reserved.
//

import UIKit

class ProfileViewController: LocalizationOrientedViewController {

    @IBOutlet weak var personalInfo: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var phoneNo: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var vehicleInfo: UILabel!
    @IBOutlet weak var liscenceNo: UILabel!
    @IBOutlet weak var plateNo: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        personalInfo.text = LanguageHelper.getStringLocalized("personal_info")
        vehicleInfo.text = LanguageHelper.getStringLocalized("vehicle_info")
        
        userName.text = MainContainerViewController.driver.getName()
        phoneNo.text = MainContainerViewController.driver.getPhone()
        email.text = MainContainerViewController.driver.getEmail()
        liscenceNo.text = MainContainerViewController.driver.getLiscenceNo()
        plateNo.text = MainContainerViewController.driver.getPlateNo()
    }
}
