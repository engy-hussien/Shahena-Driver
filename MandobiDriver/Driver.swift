//
//  Driver.swift
//  MandobiDriver
//
//  Created by ِAmr on 1/30/17.
//  Copyright © 2017 Applexicon. All rights reserved.
//

enum DriverStatus {
    case offline
    case free
    case newOrderReceived
    case inTrip
}

protocol DriverStatusChangedDelegate {
    func offlineStatus()
    func freeStatus()
    func newOrderReceivedStatus()
    func inTripStatus()
}

class Driver {
    
    fileprivate var id: Int!
    fileprivate var name,imgUrl,phone,email,liscenceNo,plateNo: String!
    var delegate: DriverStatusChangedDelegate!
    var status : DriverStatus = .offline {
        didSet {
            switch status {
            case .offline:
                delegate.offlineStatus()
            case .free:
                delegate.freeStatus()
            case .newOrderReceived:
                delegate.newOrderReceivedStatus()
            case .inTrip:
                delegate.inTripStatus()
            }
        }
    }
    fileprivate var lat,lng: Double!
    fileprivate var order: Order!
    
    init() {
        name = ""
        imgUrl = ""
        phone = ""
        email = ""
        liscenceNo = ""
        plateNo = ""
    }
    
    func setId(_ id: Int) {
        self.id = id
    }
    
    func getId() -> Int {
        return id
    }
    
    func setName(_ name: String) {
        self.name = name
    }
    
    func getName() -> String {
        return name
    }
    
    func setImgUrl(_ imgUrl: String) {
        self.imgUrl = imgUrl
    }
    
    func getImgUrl() -> String {
        return imgUrl
    }
    
    func setPhone(_ phone: String) {
        self.phone = phone
    }
    
    func getPhone() -> String {
        return phone
    }
    
    func setEmail(_ email: String) {
        self.email = email
    }
    
    func getEmail() -> String {
        return email
    }
    
    func setLiscenceNo(_ liscenceNo: String) {
        self.liscenceNo = liscenceNo
    }
    
    func getLiscenceNo() -> String {
        return liscenceNo
    }
    
    func setPlateNo(_ plateNo: String) {
        self.plateNo = plateNo
    }
    
    func getPlateNo() -> String {
        return plateNo
    }
    
    func setStatus(_ status: DriverStatus) {
        self.status = status
    }
    
    func getStatus() -> DriverStatus {
        return status
    }
    
    func setOrder(_ order: Order!) {
        self.order = order
    }
    
    func getOrder() -> Order! {
        return order
    }
    
    func setLat(_ lat: Double) {
        self.lat = lat
    }
    
    func getLat() -> Double {
        return lat
    }
    
    func setLng(_ lng: Double) {
        self.lng = lng
    }
    
    func getLng() -> Double {
        return lng
    }
    
}
