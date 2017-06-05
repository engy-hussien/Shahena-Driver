//
//  ProfitViewController.swift
//  MandobiDriver
//
//  Created by ِAmr on 1/24/17.
//  Copyright © 2017 Applexicon. All rights reserved.
//

import UIKit

class ProfitViewController: LocalizationOrientedViewController  , UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var myOrdersProfits: UILabel!
    @IBOutlet weak var income: UILabel!
    @IBOutlet weak var profit: UILabel!
    @IBOutlet weak var paid: UILabel!
    @IBOutlet weak var rest: UILabel!
    @IBOutlet weak var incomeAmount: UILabel!
    @IBOutlet weak var profitAmount: UILabel!
    @IBOutlet weak var paidAmount: UILabel!
    @IBOutlet weak var restAmount: UILabel!
    @IBOutlet weak var historyDate: UILabel!
    @IBOutlet weak var from: UILabel!
    @IBOutlet weak var to: UILabel!
    @IBOutlet weak var fromDate: UILabel!
    @IBOutlet weak var toDate: UILabel!
    @IBOutlet weak var changeFrom: UILabel!
    @IBOutlet weak var changeTo: UILabel!
    @IBOutlet weak var changingIncome: UILabel!
    @IBOutlet weak var changingProfit: UILabel!
    @IBOutlet weak var changingPaid: UILabel!
    @IBOutlet weak var changingRest: UILabel!
    @IBOutlet weak var changingIncomeAmount: UILabel!
    @IBOutlet weak var changingProfitAmount: UILabel!
    @IBOutlet weak var changingPaidAmount: UILabel!
    @IBOutlet weak var changingRestAmount: UILabel!
    @IBOutlet weak var submitBtn: UIButton!
    
    static var instance : ProfitViewController!
    
    var fromOrTo: String!
    
    var serverFromDate: String!
    var serverToDate: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ProfitViewController.instance = self
        
        self.navigationItem.title = LanguageHelper.getStringLocalized("profit")
        
        myOrdersProfits.text = LanguageHelper.getStringLocalized("my_orders_profits")
        income.text = LanguageHelper.getStringLocalized("income")
        profit.text = LanguageHelper.getStringLocalized("profit")
        paid.text = LanguageHelper.getStringLocalized("paid_amount")
        paid.numberOfLines = 0
        rest.text = LanguageHelper.getStringLocalized("rest_amount")
        rest.numberOfLines = 0
        historyDate.text = LanguageHelper.getStringLocalized("history_date")
        from.text = LanguageHelper.getStringLocalized("from")
        to.text = LanguageHelper.getStringLocalized("to")
        changeFrom.text = LanguageHelper.getStringLocalized("change")
        changeTo.text = LanguageHelper.getStringLocalized("change")
        changingIncome.text = LanguageHelper.getStringLocalized("income")
        changingProfit.text = LanguageHelper.getStringLocalized("profit")
        changingPaid.text = LanguageHelper.getStringLocalized("paid_amount")
        changingRest.text = LanguageHelper.getStringLocalized("rest_amount")
        submitBtn.setTitle(LanguageHelper.getStringLocalized("calculate"), for: .normal)
        
        let fromDateGesture = UITapGestureRecognizer(target: self, action: #selector(ProfitViewController.chooseFrom))
        fromDate.addGestureRecognizer(fromDateGesture)

        let changeFromGesture = UITapGestureRecognizer(target: self, action: #selector(ProfitViewController.chooseFrom))
        changeFrom.addGestureRecognizer(changeFromGesture)

        let toDateGesture = UITapGestureRecognizer(target: self, action: #selector(ProfitViewController.chooseTo))
        toDate.addGestureRecognizer(toDateGesture)

        let changeToGesture = UITapGestureRecognizer(target: self, action: #selector(ProfitViewController.chooseTo))
        changeTo.addGestureRecognizer(changeToGesture)
        print("driverId\(UserData.getDriverId()!)")
        
        Request.getInstance().post(Links.DRIVER_PROFIT, params: "driver_id=\(UserData.getDriverId()!)", view: self, completion: {data in
            print(data)
            self.profitAmount.text = "\(data["netProfit"] as! Float)"
            self.paidAmount.text = "\(data["paidAmount"] as! Float)"
            if data["restAmount"] as! Float >= 0 {
                self.restAmount.textColor = UIColor.green
            } else {
                self.restAmount.textColor = UIColor.red
            }
            self.restAmount.text = "\(data["restAmount"] as! Float)"
            self.incomeAmount.text = "\(data["totalAmount"] as! Float)"
            
        })
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        let serverDateFormatter = DateFormatter()
        serverDateFormatter.dateFormat = "yyyy-MM-dd"
        
        toDate.text = dateFormatter.string(from: Date())
        serverToDate = serverDateFormatter.string(from: Date())
        
        if UserData.getDriverFirstDate() != nil {
            fromDate.text = dateFormatter.string(from: UserData.getDriverFirstDate())
            serverFromDate = serverDateFormatter.string(from: UserData.getDriverFirstDate())
        } else {
            fromDate.text = dateFormatter.string(from: Date())
            serverFromDate = serverDateFormatter.string(from: Date())
        }
    }
    
    func chooseFrom() {
        fromOrTo = "from"
        DialogsHelper.getInstance().showPopUp(self, popUp: UIStoryboard(name: "PopUps", bundle: nil).instantiateViewController(withIdentifier: "datePicker"))
    }
    
    func chooseTo() {
        fromOrTo = "to"
        DialogsHelper.getInstance().showPopUp(self, popUp: UIStoryboard(name: "PopUps", bundle: nil).instantiateViewController(withIdentifier: "datePicker"))
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    @IBAction func calculate(_ sender: Any) {
        Request.getInstance().post(Links.DRIVER_PROFIT, params: "driver_id=\(UserData.getDriverId()!)&from_date=\(serverFromDate)&to_date=\(serverToDate)", view: self, completion: {data in
            print(data)
            self.changingProfitAmount.text = "\(data["netProfit"] as! Float)"
            self.changingPaidAmount.text = "\(data["paidAmount"] as! Float)"
            if data["restAmount"] as! Float >= 0 {
                self.changingRestAmount.textColor = UIColor.green
            } else {
                self.changingRestAmount.textColor = UIColor.red
            }
            self.changingRestAmount.text = "\(data["restAmount"] as! Float)"
            self.changingIncomeAmount.text = "\(data["totalAmount"] as! Float)"
            
        })
    }
}
