//
//  DatePickerViewController.swift
//  MandobiDriver
//
//  Created by ِAmr on 2/10/17.
//  Copyright © 2017 Applexicon. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        okBtn.setTitle(LanguageHelper.getStringLocalized("ok"), for: .normal)
        cancelBtn.setTitle(LanguageHelper.getStringLocalized("cancel"), for: .normal)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func okAction(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        let serverDateFormatter = DateFormatter()
        serverDateFormatter.dateFormat = "yyyy-MM-dd"
        
        if ProfitViewController.instance.fromOrTo == "from" {
            ProfitViewController.instance.fromDate.text = dateFormatter.string(from: datePicker.date)
            ProfitViewController.instance.serverFromDate = serverDateFormatter.string(from: datePicker.date)
        } else {
            ProfitViewController.instance.toDate.text = dateFormatter.string(from: datePicker.date)
            ProfitViewController.instance.serverToDate = serverDateFormatter.string(from: datePicker.date)
        }
        
        dismiss(animated: true, completion: nil)
    }
}
