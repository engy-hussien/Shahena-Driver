//
//  InfoViewController.swift
//  MandobiDriver
//
//  Created by ِAmr on 1/26/17.
//  Copyright © 2017 Applexicon. All rights reserved.
//

import UIKit

class InfoViewController: LocalizationOrientedViewController {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var from: UILabel!
    @IBOutlet weak var fromAddress: UILabel!
    @IBOutlet weak var to: UILabel!
    @IBOutlet weak var toAddress: UILabel!
    @IBOutlet weak var sentTo: UILabel!
    @IBOutlet weak var sentToPerson: UILabel!
    @IBOutlet weak var fees: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var currency: UILabel!
    @IBOutlet weak var order: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var recommendedPlaces: UILabel!
    @IBOutlet weak var recommendedPlacesTxt: UILabel!
    @IBOutlet weak var lastLine: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        order.text = LanguageHelper.getStringLocalized("order")
        from.text = LanguageHelper.getStringLocalized("from")
        to.text = LanguageHelper.getStringLocalized("to")
        fees.text = LanguageHelper.getStringLocalized("fees")
        currency.text = LanguageHelper.getStringLocalized("sar")
        
        productDescription.text = MainContainerViewController.driver.getOrder().getDescription()
        fromAddress.text = MainContainerViewController.driver.getOrder().getFromAddress()
        toAddress.text = MainContainerViewController.driver.getOrder().getToAddress()
        amount.text = MainContainerViewController.driver.getOrder().getAmount()
        type.text = MainContainerViewController.driver.getOrder().getType()
        
        if MainContainerViewController.driver.getOrder().getType() == "deliver" {
            sentToPerson.text = MainContainerViewController.driver.getOrder().getReceiverName()
            sentTo.text = LanguageHelper.getStringLocalized("sent_to")
            recommendedPlaces.isHidden = true
            recommendedPlacesTxt.isHidden = true
            lastLine.alpha = 0
        } else {
            sentTo.text = LanguageHelper.getStringLocalized("category")
            recommendedPlaces.text = LanguageHelper.getStringLocalized("recommended_places")
            sentToPerson.text = LanguageHelper.getCurrentLanguage() == "ar" ? MainContainerViewController.driver.getOrder().getCategoryAr() : MainContainerViewController.driver.getOrder().getCategoryEn()
            recommendedPlacesTxt.text = MainContainerViewController.driver.getOrder().getRecommendedPlaces()
        }
        
        let data: Data = Data(base64Encoded: MainContainerViewController.driver.getOrder().getProductImgUrl() , options: .ignoreUnknownCharacters)!
        // turn  Decoded String into Data
        let dataImage = UIImage(data: data as Data)
        // pass the data image to image View.:)
        productImage.image = dataImage
    }

}
