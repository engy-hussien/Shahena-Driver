//
//  Order.swift
//  MandobiDriver
//
//  Created by ِAmr on 1/30/17.
//  Copyright © 2017 Applexicon. All rights reserved.
//

class Order {
    fileprivate var id,fromAddress,toAddress,amount,receiverName,receiverPhone,categoryAr,categoryEn,recommendedPlaces,productImgUrl,description,type,clientPhone,clientId: String!
    fileprivate var fromLat,fromLng,toLat,toLng: Double!
    
    fileprivate var messages = [Message]()
    
    init(id: String,fromLat: Double,fromLng: Double,fromAddress: String,toLat: Double,toLng: Double,toAddress: String,amount: String,receiverName: String,receiverPhone: String,categoryAr: String,categoryEn: String,recommendedPlaces: String,productImgUrl: String,description: String,type: String,clientPhone: String,clientId: String) {
        setId(id)
        setFromLat(fromLat)
        setFromLng(fromLng)
        setFromAddress(fromAddress)
        setToLat(toLat)
        setToLng(toLng)
        setToAddress(toAddress)
        setAmount(amount)
        setReceiverName(receiverName)
        setReceiverPhone(receiverPhone)
        setCategoryAr(categoryAr)
        setCategoryEn(categoryEn)
        setRecommendedPlaces(recommendedPlaces)
        setProductImgUrl(productImgUrl)
        setDescription(description)
        setType(type)
        setClientPhone(clientPhone)
        setClientId(clientId)
    }
    
    func setId(_ id: String) {
        self.id = id
    }
    
    func getId() -> String {
        return id
    }
    
    func setFromLat(_ fromLat: Double) {
        self.fromLat = fromLat
    }
    
    func getFromLat() -> Double {
        return fromLat
    }
    
    func setFromLng(_ fromLng: Double) {
        self.fromLng = fromLng
    }
    
    func getFromLng() -> Double {
        return fromLng
    }
    
    func setFromAddress(_ fromAddress: String) {
        self.fromAddress = fromAddress
    }
    
    func getFromAddress() -> String {
        return fromAddress
    }
    
    func setToLat(_ toLat: Double) {
        self.toLat = toLat
    }
    
    func getToLat() -> Double {
        return toLat
    }
    
    func setToLng(_ toLng: Double) {
        self.toLng = toLng
    }
    
    func getToLng() -> Double {
        return toLng
    }
    
    func setToAddress(_ toAddress: String) {
        self.toAddress = toAddress
    }
    
    func getToAddress() -> String {
        return toAddress
    }
    
    func setAmount(_ amount: String) {
        self.amount = amount
    }
    
    func getAmount() -> String {
        return amount
    }
    
    func setReceiverName(_ receiverName: String) {
        self.receiverName = receiverName
    }
    
    func getReceiverName() -> String {
        return receiverName
    }
    
    func setReceiverPhone(_ receiverPhone: String) {
        self.receiverPhone = receiverPhone
    }
    
    func getReceiverPhone() -> String {
        return receiverPhone
    }
    
    func setCategoryAr(_ categoryAr: String) {
        self.categoryAr = categoryAr
    }
    
    func getCategoryAr() -> String {
        return categoryAr
    }
    
    func setCategoryEn(_ categoryEn: String) {
        self.categoryEn = categoryEn
    }
    
    func getCategoryEn() -> String {
        return categoryEn
    }
    
    func setRecommendedPlaces(_ recommendedPlaces: String) {
        self.recommendedPlaces = recommendedPlaces
    }
    
    func getRecommendedPlaces() -> String {
        return recommendedPlaces
    }
    
    func setProductImgUrl(_ productImgUrl: String) {
        self.productImgUrl = productImgUrl
    }
    
    func getProductImgUrl() -> String {
        return productImgUrl
    }
    
    func setDescription(_ description: String) {
        self.description = description
    }
    
    func getDescription() -> String {
        return description
    }
    
    func setType(_ type: String) {
        self.type = type
    }
    
    func getType() -> String {
        return type
    }
    
    func setClientPhone(_ clientPhone: String) {
        self.clientPhone = clientPhone
    }
    
    func getClientPhone() -> String {
        return clientPhone
    }
    
    func setClientId(_ clientId: String) {
        self.clientId = clientId
    }
    
    func getClientId() -> String {
        return clientId
    }
    
    func addMessage(_ message: Message) {
        messages.append(message)
    }
    
    func getMessages() -> [Message] {
        return messages
    }
}
