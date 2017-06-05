//
//  SocketIOController.swift
//  Mandobi
//
//  Created by ِAmr on 1/15/17.
//  Copyright © 2017 Applexicon. All rights reserved.
//

import UIKit
import SocketIO
import SystemConfiguration

protocol SocketIOControllorResponseDelegate : class {
    func actionReceived(_ actionName: String,parameters: NSDictionary!)
    func notConnected()
    func connected()
}

class SocketIOController {
    
    fileprivate static var socket : SocketIOClient!
    static weak var delegate : SocketIOControllorResponseDelegate?
    
    static func initiate() {
        if Request.getInstance().isConnected() {
            if socket == nil {
                socket = SocketIOClient(socketURL: URL(string: Links.SOCKET_URL)!, config: [.log(true), .forcePolling(true)])
            
                makeConnection()
                
                UserData.setDriverStatus(true)
            }
        } else {
            delegate?.notConnected()
        }
    }
    
    static func makeConnection() {
        socket.on("connect") {data, ack in
            print("socket connected")
            delegate?.connected()
            emitEvent(SocketEvents.INIT_SERVER_CONNECTION, withParameters: ["id":UserData.getDriverId() as AnyObject,"type":"driver" as AnyObject])
        }
        
        setUpHandlers()
        
        socket.connect()
    }
    
    static func makeDisconnection() {
        if socket != nil {
            socket.disconnect()
            socket = nil
        }
        MainContainerViewController.driver.setStatus(.offline)
        UserData.setDriverStatus(false)
    }
    
    static func setUpHandlers() {
        socket.on("setToken") {data, ack in
            print("setToken received with \(data[0] as! NSDictionary)")
            UserData.setDriverToken((data[0] as! NSDictionary)["connToken"] as! String)
            delegate?.actionReceived("setToken", parameters: nil)
        }
        
        socket.on("newOrderReceived") {data, ack in
            print("newOrderReceived received with \(data[0] as! NSDictionary)")
            delegate?.actionReceived("newOrderReceived", parameters: data[0] as! NSDictionary)
        }
        
        socket.on("orderAlreadyAccepted") {data, ack in
            print("orderAlreadyAccepted received")
            delegate?.actionReceived("orderAlreadyAccepted", parameters: nil)
        }
        
        socket.on("anotherDriverSelected") {data, ack in
            print("anotherDriverSelected received")
            delegate?.actionReceived("anotherDriverSelected", parameters: nil)
        }
        
        socket.on("suggestionAccepted") {data, ack in
            print("suggestionAccepted received")
            delegate?.actionReceived("suggestionAccepted", parameters: nil)
        }
        
        socket.on("messageReceived") {data, ack in
            print("messageReceived received with \(data[0] as! NSDictionary)")
            delegate?.actionReceived("messageReceived", parameters: data[0] as! NSDictionary)
        }
        
        socket.on("tripReview") {data, ack in
            print("tripReview received with \(data[0] as! NSDictionary)")
            delegate?.actionReceived("tripReview", parameters: data[0] as! NSDictionary)
        }
        
        socket.on("clientCancelTrip") {data, ack in
            print("clientCancelTrip received")
            delegate?.actionReceived("clientCancelTrip", parameters: nil)
        }
        
        socket.on("currentTripDetails") {data, ack in
            print("currentTripDetails received with \(data[0] as! NSDictionary)")
            delegate?.actionReceived("currentTripDetails", parameters: data[0] as! NSDictionary)
        }
        
        socket.on("getDriverInvoice") {data, ack in
            print("getDriverInvoice received with \(data[0] as! NSDictionary)")
            delegate?.actionReceived("getDriverInvoice", parameters: data[0] as! NSDictionary)
        }
    }
    
    static func emitEvent(_ event: String,withParameters: [String:AnyObject]) {
        if !Request.getInstance().isConnected() {
            delegate?.notConnected()
        } else if socket != nil  && MainContainerViewController.driver.getStatus() != .offline {
            socket.emit(event,withParameters)
        }
    }
    
}
