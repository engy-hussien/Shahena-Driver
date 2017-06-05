//
//  NewOrderViewController.swift
//  MandobiDriver
//
//  Created by ِAmr on 1/25/17.
//  Copyright © 2017 Applexicon. All rights reserved.
//

import UIKit

class NewOrderViewController: LocalizationOrientedViewController , TimerDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var orderImage: UIImageView!
    @IBOutlet weak var deadLineLbl: UILabel!
    @IBOutlet weak var counter: UILabel!
    @IBOutlet weak var second: UILabel!
    @IBOutlet weak var fees: UILabel!
    @IBOutlet weak var currency: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var orderDescription: UILabel!
    @IBOutlet weak var from: UILabel!
    @IBOutlet weak var fromAddress: UILabel!
    @IBOutlet weak var to: UILabel!
    @IBOutlet weak var toAddress: UILabel!
    @IBOutlet weak var sentTo: UILabel!
    @IBOutlet weak var sentToPerson: UILabel!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var writeSuggest: UILabel!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var currencyEdit: UILabel!
    @IBOutlet weak var suggestedAmount: UITextField!
    @IBOutlet weak var order: UILabel!
    @IBOutlet weak var orderType: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var phoneNo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deadLineLbl.text = LanguageHelper.getStringLocalized("dead_line")
        second.text = LanguageHelper.getStringLocalized("second")
        fees.text = LanguageHelper.getStringLocalized("fees")
        currency.text = LanguageHelper.getStringLocalized("sar")
        from.text = LanguageHelper.getStringLocalized("from")
        to.text = LanguageHelper.getStringLocalized("to")
        writeSuggest.text = LanguageHelper.getStringLocalized("write_suggest")
        currencyEdit.text = LanguageHelper.getStringLocalized("sar")
        order.text = LanguageHelper.getStringLocalized("order")
        
        acceptBtn.setTitle(LanguageHelper.getStringLocalized("accept"), for: .normal)
        cancelBtn.setTitle(LanguageHelper.getStringLocalized("cancel"), for: .normal)
        sendBtn.setTitle(LanguageHelper.getStringLocalized("send"), for: .normal)
        
        sendBtn.layer.cornerRadius = 5
        
        orderDescription.numberOfLines = 0
        writeSuggest.numberOfLines = 0
        
        amount.text = MainContainerViewController.driver.getOrder().getAmount()
        orderType.text = MainContainerViewController.driver.getOrder().getType()
        orderDescription.text = MainContainerViewController.driver.getOrder().getDescription()
        fromAddress.text = MainContainerViewController.driver.getOrder().getFromAddress()
        toAddress.text = MainContainerViewController.driver.getOrder().getToAddress()
        
        if MainContainerViewController.driver.getOrder().getType() == "deliver" {
            sentToPerson.text = MainContainerViewController.driver.getOrder().getReceiverName()
            sentTo.text = LanguageHelper.getStringLocalized("sent_to")
            phoneNo.text = MainContainerViewController.driver.getOrder().getReceiverPhone()
            phone.text = LanguageHelper.getStringLocalized("phone")
        } else {
            sentToPerson.text = LanguageHelper.getCurrentLanguage() == "ar" ? MainContainerViewController.driver.getOrder().getCategoryAr() : MainContainerViewController.driver.getOrder().getCategoryEn()
            sentTo.text = LanguageHelper.getStringLocalized("category")
            phoneNo.text = MainContainerViewController.driver.getOrder().getRecommendedPlaces()
            phone.text = LanguageHelper.getStringLocalized("recommended_places")
        }
        
        counter.text = "\(MainViewController.instance.counter)"
        MainViewController.instance.timerDelegate = self
        
        
        let data: Data = Data(base64Encoded: MainContainerViewController.driver.getOrder().getProductImgUrl() , options: .ignoreUnknownCharacters)!
        // turn  Decoded String into Data
        let dataImage = UIImage(data: data as Data)
        // pass the data image to image View.:)
        orderImage.image = dataImage
        
    }
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
        scrollView.contentSize = CGSize(width: 300, height: 500 + orderDescription.frame.height)
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        MainViewController.instance.player?.stop()
//    }

    
    func timerFinished() {
        dismiss(animated: true, completion: nil)
    }
    
    func timerUpdate() {
        counter.text = "\(MainViewController.instance.counter)"
    }
    

    @IBAction func acceptAction(_ sender: Any) {
        MainViewController.instance.stopTimer()
        MainContainerViewController.driver.status = .inTrip
        if let _ = MainContainerViewController.driver.getOrder() {
            SocketIOController.emitEvent(SocketEvents.ACCEPT_ORDER, withParameters: ["connToken":UserData.getDriverToken() as AnyObject,"orderId":MainContainerViewController.driver.getOrder().getId() as AnyObject])
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        MainViewController.instance.stopTimer()
        MainContainerViewController.driver.status = .free
        MainContainerViewController.driver.setOrder(nil)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendAction(_ sender: Any) {
        let formatter: NumberFormatter = NumberFormatter()
        
        formatter.locale = Locale(identifier: "EN") as Locale!
        
        if suggestedAmount.text == "" {
            DialogsHelper.getInstance().showBottomAlert(LanguageHelper.getStringLocalized("enter_fees"), view: self)
        } else if Int(formatter.number(from: suggestedAmount.text!)!) <= Int(formatter.number(from: amount.text!)!) {
            DialogsHelper.getInstance().showBottomAlert(LanguageHelper.getStringLocalized("enter_greater_no"), view: self)
        } else {
            MainViewController.instance.stopTimer()
            SocketIOController.emitEvent(SocketEvents.SUGGEST_PRICE, withParameters: ["connToken":UserData.getDriverToken() as AnyObject,"orderId":MainContainerViewController.driver.getOrder().getId() as AnyObject,"amount":suggestedAmount.text as AnyObject])
            dismiss(animated: true, completion: nil)
            MainViewController.instance.waitForSuggestionResponse()
            MainContainerViewController.driver.getOrder().setAmount(suggestedAmount.text!)
        }
    }
}
