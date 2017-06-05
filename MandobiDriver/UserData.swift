//
//  UserData.swift
//  MandobiDriver
//
//  Created by ِAmr on 1/22/17.
//  Copyright © 2017 Applexicon. All rights reserved.
//
import UIKit

class UserData {
    
    static func setUserLangugae(_ languageCode: String) {
        let defaults = UserDefaults.standard
        defaults.setValue(languageCode, forKey: "language")
        defaults.synchronize()
        print("language saved")
    }
    
    static func getUserLanguage() -> String! {
        let defaults = UserDefaults.standard
        return defaults.value(forKey: "language") as! String!
    }
    
    static func setDriverStatus(_ isOnline: Bool) {
        let defaults = UserDefaults.standard
        defaults.setValue(isOnline, forKey: "driverStatus")
        defaults.synchronize()
        print("driverStatus saved")
    }
    
    static func isDriverOnline() -> Bool! {
        let defaults = UserDefaults.standard
        return defaults.value(forKey: "driverStatus") as! Bool!
    }
    
    static func setDriverId(_ driverId: Int) {
        let defaults = UserDefaults.standard
        defaults.setValue(driverId, forKey: "driverId")
        defaults.synchronize()
        print("driverId saved")
    }
    
    static func getDriverId() -> Int! {
        let defaults = UserDefaults.standard
        return defaults.value(forKey: "driverId") as! Int!
    }
    
    static func setDriverLoggedIn(_ isLogged: Bool) {
        let defaults = UserDefaults.standard
        defaults.setValue(isLogged, forKey: "driverLoggedIn")
        defaults.synchronize()
        print("driverLoggedIn saved")
    }
    
    static func isDriverLoggedIn() -> Bool {
        let defaults = UserDefaults.standard
        if defaults.value(forKey: "driverLoggedIn") != nil {
            return defaults.value(forKey: "driverLoggedIn") as! Bool
        }
        return false
    }
    
    static func setDriverToken(_ connectionToken: String) {
        let defaults = UserDefaults.standard
        defaults.setValue(connectionToken, forKey: "connectionToken")
        defaults.synchronize()
        print("connectionToken saved")
    }
    
    static func getDriverToken() -> String! {
        let defaults = UserDefaults.standard
        return defaults.value(forKey: "connectionToken") as! String!
    }
    
    static func saveDriverData(_ name: String,imgUrl: String,phone: String,email: String,liscenceNo: String,plateNo: String) {
        setDriverName(name)
        setDriverImgUrl(imgUrl)
        setDriverPhone(phone)
        setDriverEmail(email)
        setDriverLiscenceNo(liscenceNo)
        setDriverPlateNo(plateNo)
    }
    
    static func setDriverName(_ name: String) {
        let defaults = UserDefaults.standard
        defaults.setValue(name, forKey: "name")
        defaults.synchronize()
        print("name saved")
    }
    
    static func getDriverName() -> String! {
        let defaults = UserDefaults.standard
        return defaults.value(forKey: "name") as! String!
    }
    
    static func setDriverImgUrl(_ imgUrl: String) {
        let defaults = UserDefaults.standard
        defaults.setValue(imgUrl, forKey: "imgUrl")
        defaults.synchronize()
        print("imgUrl saved")
    }
    
    static func getDriverImgUrl() -> String! {
        let defaults = UserDefaults.standard
        return defaults.value(forKey: "imgUrl") as! String!
    }
    
    static func setDriverPhone(_ phone: String) {
        let defaults = UserDefaults.standard
        defaults.setValue(phone, forKey: "phone")
        defaults.synchronize()
        print("phone saved")
    }
    
    static func getDriverPhone() -> String! {
        let defaults = UserDefaults.standard
        return defaults.value(forKey: "phone") as! String!
    }
    
    static func setDriverEmail(_ email: String) {
        let defaults = UserDefaults.standard
        defaults.setValue(email, forKey: "email")
        defaults.synchronize()
        print("email saved")
    }
    
    static func getDriverEmail() -> String! {
        let defaults = UserDefaults.standard
        return defaults.value(forKey: "email") as! String!
    }
    
    static func setDriverLiscenceNo(_ liscenceNo: String) {
        let defaults = UserDefaults.standard
        defaults.setValue(liscenceNo, forKey: "liscenceNo")
        defaults.synchronize()
        print("liscenceNo saved")
    }
    
    static func getDriverLiscenceNo() -> String! {
        let defaults = UserDefaults.standard
        return defaults.value(forKey: "liscenceNo") as! String!
    }
    
    static func setDriverPlateNo(_ plateNo: String) {
        let defaults = UserDefaults.standard
        defaults.setValue(plateNo, forKey: "plateNo")
        defaults.synchronize()
        print("plateNo saved")
    }
    
    static func getDriverPlateNo() -> String! {
        let defaults = UserDefaults.standard
        return defaults.value(forKey: "plateNo") as! String!
    }
    
    static func setDriverFirstDate(_ firstDate: Date) {
        let defaults = UserDefaults.standard
        defaults.setValue(firstDate, forKey: "firstDate")
        defaults.synchronize()
        print("firstDate saved")
    }
    
    static func getDriverFirstDate() -> Date! {
        let defaults = UserDefaults.standard
        return defaults.value(forKey: "firstDate") as! Date!
    }
    
}
