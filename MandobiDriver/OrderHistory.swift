//
//  OrderHistory.swift
//  MandobiDriver
//
//  Created by ِAmr on 1/29/17.
//  Copyright © 2017 Applexicon. All rights reserved.
//

class OrderHistory {
    
    fileprivate var id: Int!
    fileprivate var date,amount,fromAddress,toAddress,type: String!
    
    init(id: Int,date: String,amount: String,fromAddress: String,toAddress: String,type: String) {
        setId(id)
        setDate(date)
        setAmount(amount)
        setFromAddress(fromAddress)
        setToAddress(toAddress)
        setType(type)
    }
    
    func getId() -> Int {
        return id
    }
    
    func setId(_ id: Int) {
        self.id = id
    }
    
    
    func getDate() -> String {
        return date
    }
    
    func setDate(_ date: String) {
        self.date = date
    }
    
    func getAmount() -> String {
        return amount
    }
    
    func setAmount(_ amount: String) {
        self.amount = amount
    }
    
    func getFromAddress() -> String {
        return fromAddress
    }
    
    func setFromAddress(_ fromAddress: String) {
        self.fromAddress = fromAddress
    }
    
    func getToAddress() -> String {
        return toAddress
    }
    
    func setToAddress(_ toAddress: String) {
        self.toAddress = toAddress
    }
    
    func getType() -> String {
        return type
    }
    
    func setType(_ type: String) {
        self.type = type
    }
    
}
