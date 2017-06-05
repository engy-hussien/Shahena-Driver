//
//  OrdersHistoryViewController.swift
//  MandobiDriver
//
//  Created by ِAmr on 1/24/17.
//  Copyright © 2017 Applexicon. All rights reserved.
//

import UIKit

class OrdersHistoryViewController: LocalizationOrientedViewController , UITableViewDelegate , UITableViewDataSource {

    @IBOutlet weak var segmented: UISegmentedControl!
    @IBOutlet weak var ordersTableView: UITableView!
    
    var openOrdersHistory = [OrderHistory]()
    var excutedOrdersHistory = [OrderHistory]()
    var cancelledOrdersHistory = [OrderHistory]()
    
    var deliver = UIImage(named: "deliver_myorders")
    var bring = UIImage(named: "bring_myorders")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ordersTableView.delegate = self
        ordersTableView.dataSource = self
        
        self.navigationItem.title = LanguageHelper.getStringLocalized("orders_history")
        segmented.setTitle(LanguageHelper.getStringLocalized("open"), forSegmentAt: 0)
        segmented.setTitle(LanguageHelper.getStringLocalized("excuted"), forSegmentAt: 1)
        segmented.setTitle(LanguageHelper.getStringLocalized("cancelled"), forSegmentAt: 2)
        
        Request.getInstance().post(Links.OPEN_ORDERS_HISTORY, params: "driver_id=\(UserData.getDriverId()!)", view: self, completion: {data in
            let ordersList = data["ordersList"] as! NSArray
            for index in 0..<ordersList.count {
                let orderListData = ordersList[index] as! NSDictionary
                self.openOrdersHistory.append(OrderHistory(id: Int(orderListData["order_id"] as! String)!,date: orderListData["order_time"] as! String, amount: orderListData["order_cost"] as! String, fromAddress: orderListData["order_start_location"] as! String, toAddress: orderListData["order_end_location"] as! String, type: orderListData["trip_type"] as! String))
            }
            self.ordersTableView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmented.selectedSegmentIndex {
        case 0:
            return openOrdersHistory.count
        case 1:
            return excutedOrdersHistory.count
        case 2:
            return cancelledOrdersHistory.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderHistory") as! OrderHistoryTableViewCell
        
        switch segmented.selectedSegmentIndex {
        case 0:
            cell.date.text = openOrdersHistory[indexPath.row].getDate()
            cell.fees.text = openOrdersHistory[indexPath.row].getAmount()
            cell.fromAddress.text = openOrdersHistory[indexPath.row].getFromAddress()
            cell.toAddress.text = openOrdersHistory[indexPath.row].getToAddress()
            cell.bringOrDeliverImg.image = openOrdersHistory[indexPath.row].getType() == "deliver" ? deliver: bring
        case 1:
            cell.date.text = excutedOrdersHistory[indexPath.row].getDate()
            cell.fees.text = excutedOrdersHistory[indexPath.row].getAmount()
            cell.fromAddress.text = excutedOrdersHistory[indexPath.row].getFromAddress()
            cell.toAddress.text = excutedOrdersHistory[indexPath.row].getToAddress()
            cell.bringOrDeliverImg.image = excutedOrdersHistory[indexPath.row].getType() == "deliver" ? deliver: bring
        case 2:
            cell.date.text = cancelledOrdersHistory[indexPath.row].getDate()
            cell.fees.text = cancelledOrdersHistory[indexPath.row].getAmount()
            cell.fromAddress.text = cancelledOrdersHistory[indexPath.row].getFromAddress()
            cell.toAddress.text = cancelledOrdersHistory[indexPath.row].getToAddress()
            cell.bringOrDeliverImg.image = cancelledOrdersHistory[indexPath.row].getType() == "deliver" ? deliver: bring
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segmented.selectedSegmentIndex == 0 {
            if MainContainerViewController.driver.getOrder() == nil {
                SocketIOController.emitEvent(SocketEvents.CURRENT_TRIP, withParameters: ["orderId": openOrdersHistory[indexPath.row].getId() as AnyObject,"senderType": "driver" as AnyObject])
            }
            let _ = navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func segmentCellSelected(_ sender: Any) {
        switch segmented.selectedSegmentIndex {
        case 0:
            ordersTableView.reloadData()
        case 1:
            if excutedOrdersHistory.count > 0 {
                ordersTableView.reloadData()
            } else {
                Request.getInstance().post(Links.EXCUTED_ORDERS_HISTORY, params: "driver_id=\(UserData.getDriverId()!)", view: self, completion: {data in
                    let ordersList = data["ordersList"] as! NSArray
                    for index in 0..<ordersList.count {
                        let orderListData = ordersList[index] as! NSDictionary
                        self.excutedOrdersHistory.append(OrderHistory(id: Int(orderListData["order_id"] as! String)!,date: orderListData["order_time"] as! String, amount: orderListData["order_cost"] as! String, fromAddress: orderListData["order_start_location"] as! String, toAddress: orderListData["order_end_location"] as! String, type: orderListData["trip_type"] as! String))
                    }
                    self.ordersTableView.reloadData()
                })
            }
        case 2:
            if cancelledOrdersHistory.count > 0 {
                ordersTableView.reloadData()
            } else {
                Request.getInstance().post(Links.CANCELLED_ORDERS_HISTORY, params: "driver_id=\(UserData.getDriverId()!)", view: self, completion: {data in
                    let ordersList = data["ordersList"] as! NSArray
                    for index in 0..<ordersList.count {
                        let orderListData = ordersList[index] as! NSDictionary
                        self.cancelledOrdersHistory.append(OrderHistory(id: Int(orderListData["order_id"] as! String)!,date: orderListData["order_time"] as! String, amount: orderListData["order_cost"] as! String, fromAddress: orderListData["order_start_location"] as! String, toAddress: orderListData["order_end_location"] as! String, type: orderListData["trip_type"] as! String))
                    }
                    self.ordersTableView.reloadData()
                })
            }
            
        default:
            break
        }
    }
}
