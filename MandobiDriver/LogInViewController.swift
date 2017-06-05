//
//  LogInViewController.swift
//  MandobiDriver
//
//  Created by ِAmr on 1/23/17.
//  Copyright © 2017 Applexicon. All rights reserved.
//

import UIKit

class LogInViewController: LocalizationOrientedViewController ,UITextFieldDelegate{

    @IBOutlet weak var loginLbl: UILabel!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginLbl.text = LanguageHelper.getStringLocalized("log_in")
        emailTxtField.placeholder = LanguageHelper.getStringLocalized("user_name")
        passwordTxtField.placeholder = LanguageHelper.getStringLocalized("enter_password")
        loginBtn.setTitle(LanguageHelper.getStringLocalized("log_in"), for: .normal)
        
        
//        NotificationCenter.default.addObserver(self, selector: #selector(LogInViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(LogInViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)


    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
//    func keyboardWillShow(notification: NSNotification) {
//        
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y == 0{
//                self.view.frame.origin.y -= keyboardSize.height
//            }
//        }
//        
//    }
//    
//    func keyboardWillHide(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y != 0{
//                self.view.frame.origin.y += keyboardSize.height
//            }
//        }
//    }
//    
    
    func isValidEmail(_ testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    @IBAction func doLogin(_ sender: Any) {
        if emailTxtField.text == "" || passwordTxtField.text == "" {
            DialogsHelper.getInstance().showBottomAlert(LanguageHelper.getStringLocalized("fill_data"), view: self)
//        } else if !isValidEmail(testStr: emailTxtField.text!) {
//            DialogsHelper.getInstance().showBottomAlert(msg: LanguageHelper.getStringLocalized(key: "enter_valid_email"), view: self)
        } else {
            print(Links.DRIVER_LOGIN)
            Request.getInstance().post(Links.DRIVER_LOGIN, params: "username=\(emailTxtField.text!)&password=\(passwordTxtField.text!)", view: self, completion: {
                data in
                
                UserData.setDriverLoggedIn(true)
                UserData.setDriverId(data["id"] as! Int)
                self.present(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainNav"), animated: true, completion: nil)
            })
        }
    }
}
