//
//  SplashViewController.swift
//  MandobiDriver
//
//  Created by ِAmr on 1/23/17.
//  Copyright © 2017 Applexicon. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let deadlineTime = DispatchTime.now() + .seconds(3)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            if !UserData.isDriverLoggedIn() {
                self.present(UIStoryboard(name: "UserManagement", bundle: nil).instantiateViewController(withIdentifier: "logIn"), animated: true, completion: nil)
            } else {
                self.present(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainNav"), animated: true, completion: nil)
            }
        })
    }
}
