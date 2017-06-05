//
//  InvoiceViewController.swift
//  MandobiDriver
//
//  Created by ِAmr on 2/27/17.
//  Copyright © 2017 Applexicon. All rights reserved.
//

import UIKit

class InvoiceViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {

    @IBOutlet weak var invoiceLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var okBtn: UIButton!
    
    let headers = ["total_fees","type","promotion","our_profit","your_profit"]
    
    var contents = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        invoiceLbl.text = LanguageHelper.getStringLocalized("invoice")
        okBtn.setTitle(LanguageHelper.getStringLocalized("ok"), for: .normal)
        
        okBtn.layer.cornerRadius = 5
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "invoiceCell", for: indexPath) as! InvoiceTableViewCell
        
        cell.headerLbl.text = LanguageHelper.getStringLocalized(headers[indexPath.row])
        
        cell.contentLbl.text = indexPath.row == 1 ? contents[indexPath.row] : contents[indexPath.row] + " \(LanguageHelper.getStringLocalized("sar"))"
        
        return cell
    }
    
    @IBAction func okPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
