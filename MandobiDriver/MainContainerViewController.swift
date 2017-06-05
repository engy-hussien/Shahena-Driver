//
//  MainContainerViewController.swift
//  MandobiDriver
//
//  Created by ِAmr on 1/19/17.
//  Copyright © 2017 Applexicon. All rights reserved.
//

import UIKit
import CoreLocation

enum SlideOutState {
    case bothCollapsed
    case leftPanelExpanded
    case rightPanelExpanded
}

class MainContainerViewController: UIViewController {
    var centerNavigationController: UINavigationController!
    var centerViewController: MainViewController!
    
    var currentState: SlideOutState = .bothCollapsed {
        didSet {
            let shouldShowShadow = currentState != .bothCollapsed
            showShadowForCenterViewController(shouldShowShadow)
        }
    }
    
    var rightViewController: SidePanelViewController?
    var leftViewController: SidePanelViewController?
    let centerPanelExpandedOffset: CGFloat = 60
    
    let driverState = UISwitch()
    let menuButton = UIButton()
    
    static let driver = Driver()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        MainContainerViewController.driver.delegate = self
        SocketIOController.delegate = self
    }
    
    func setUpNavigation() {
        centerViewController = UIStoryboard.centerViewController()
        centerViewController.delegate = self
        
        centerNavigationController = UINavigationController(rootViewController: centerViewController)
        view.addSubview(centerNavigationController.view)
        addChildViewController(centerNavigationController)
        
        centerNavigationController.didMove(toParentViewController: self)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(MainContainerViewController.handlePanGesture(_:)))
        centerNavigationController.view.addGestureRecognizer(panGestureRecognizer)
        
        setUpNavigationBar()
    }
    
    func setUpNavigationBar() {
        
        driverState.frame = CGRect(x: LanguageHelper.getCurrentLanguage() == "ar" ? 10 : centerNavigationController.view.frame.maxX - driverState.frame.maxX - 10, y: 30, width: driverState.frame.width, height: driverState.frame.height)
        driverState.addTarget(self, action: #selector(MainContainerViewController.driverStateChanged), for: .touchUpInside)
        
        centerNavigationController.view.addSubview(driverState)
        
        menuButton.frame = CGRect(x: LanguageHelper.getCurrentLanguage() == "ar" ? centerNavigationController.view.frame.maxX - 60 : 10, y: 30, width: 50, height: 30)
        menuButton.setImage(UIImage(named: "menu"), for: .normal)
        menuButton.addTarget(self, action: #selector(MainContainerViewController.menuButtonSelected), for: .touchUpInside)
        centerNavigationController.view.addSubview(menuButton)
        
        let logo = UIImageView(image: UIImage(named: "logo_name.png"))
        logo.frame = CGRect(x: centerNavigationController.view.frame.midX - 50,y: 35,width: 100,height: 25)
        centerNavigationController.view.addSubview(logo)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        
        if LanguageHelper.getCurrentLanguage() == "ar" {
            self.navigationController?.navigationBar.semanticContentAttribute = .forceRightToLeft
            centerNavigationController?.navigationBar.semanticContentAttribute = .forceRightToLeft
        }
        
        MainContainerViewController.driver.setId(UserData.getDriverId())
        
        if UserData.isDriverOnline() == nil || UserData.isDriverOnline() {
            SocketIOController.initiate()
        }
        
        Request.getInstance().getWithOutUIDialogs(Links.DRIVER_PROFILE + "&id=\(UserData.getDriverId() as Int)", completion: {
            data in
            
            MainContainerViewController.driver.setName(data["full_name"] is NSNull ? "" : data["full_name"] as! String)
            
            MainContainerViewController.driver.setImgUrl(data["presonal_image"] is NSNull ? "" : data["presonal_image"] as! String)
            
            MainContainerViewController.driver.setPhone(data["phone"] is NSNull ? "" : data["phone"] as! String)
            
            MainContainerViewController.driver.setEmail(data["email"] is NSNull ? "" : data["email"] as! String)
            
            MainContainerViewController.driver.setLiscenceNo(data["car_authorization"] is NSNull ? "" : data["car_authorization"] as! String)
            
            MainContainerViewController.driver.setPlateNo(data["plate_no"] is NSNull ? "" : data["plate_no"] as! String)
        })
        
        if UserData.getDriverFirstDate() == nil {
            Request.getInstance().getWithOutUIDialogs(Links.FIRST_ORDER_DATE + "&driver_id=\(UserData.getDriverId()!)", completion: {
                data in
            
                print("date \(data["date"])")
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let date = dateFormatter.date(from: data["date"] as! String)
            
                print("dateing \(date)")
                UserData.setDriverFirstDate(date!)
            })
        }
        
        driverState.isOn = UserData.isDriverOnline()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        
    }
    func menuButtonSelected() {
        if LanguageHelper.getCurrentLanguage() == "ar" {
            toggleRightPanel()
        } else {
            toggleLeftPanel()
        }
    }
    
    func driverStateChanged() {
        if Request.getInstance().isConnected() {
        if driverState.isOn {
            SocketIOController.initiate()
            MainViewController.instance.showCurrentLocation()
        } else {
            DialogsHelper.getInstance().showAlertDialog(self, title: nil, message: LanguageHelper.getStringLocalized("going_offline"), completion: { isAcceptResponse in
                if isAcceptResponse {
                    SocketIOController.makeDisconnection()
                    MainViewController.instance.stopUpdatingLocation()
                } else {
                    self.driverState.setOn(true, animated: true)
                }
            })
        }
        } else {
            if driverState.isOn {
                driverState.setOn(false, animated: true)
            } else {
                driverState.setOn(true, animated: true)
            }
            DialogsHelper.getInstance().showBottomAlert(LanguageHelper.getStringLocalized("check_internet"),view: self)
        }
    }
    
}

// MARK: SocketIOControllorResponseDelegate delegate

extension MainContainerViewController: DriverStatusChangedDelegate {
    
    func offlineStatus() {
        driverState.isHidden = false
        centerViewController.lightenFab()
    }
    
    func freeStatus() {
        driverState.isHidden = false
        centerViewController.lightenFab()
    }
    
    func newOrderReceivedStatus() {
        driverState.isHidden = true
        centerViewController.newOrderReceived()
    }
    
    func inTripStatus() {
        driverState.isHidden = true
        centerViewController.inTripStarted()
    }
}

// MARK: SocketIOControllorResponseDelegate delegate

extension MainContainerViewController: SocketIOControllorResponseDelegate {
    func notConnected() {
//        driverState.isOn = false
//        DialogsHelper.getInstance().showBottomAlert(msg: LanguageHelper.getStringLocalized(key: "check_internet"),view: self)
    }
    
    func connected() {
        MainContainerViewController.driver.status = .free
        driverState.isOn = true
    }
    
    func actionReceived(_ actionName: String, parameters: NSDictionary!) {
        switch actionName {
            case "setToken":
                print("here0")
                if centerViewController.currentLocation != nil{
                    SocketIOController.emitEvent(SocketEvents.UPDATE_DRIVER_LOCATION, withParameters: ["connToken":UserData.getDriverToken() as AnyObject,"lat":centerViewController.currentLocation.coordinate.latitude as AnyObject,"lng":centerViewController.currentLocation.coordinate.longitude as AnyObject])
                    print("here")
                }else{
                    print("here1")
                  centerViewController.showCurrentLocation()
            }
            case "newOrderReceived":
                if MainContainerViewController.driver.status == .free {
                    let order = Order(id: parameters["orderId"] as! String, fromLat: parameters["fromLatitude"] as! Double, fromLng: parameters["fromLongitude"] as! Double, fromAddress: parameters["fromAddress"] as! String, toLat: parameters["toLatitude"]  as! Double, toLng: parameters["toLongitude"] as! Double, toAddress: parameters["toAddress"] as! String, amount: parameters["amount"] as! String, receiverName: parameters["type"] as! String == "deliver" ? parameters["receiverName"] as! String : "", receiverPhone: parameters["type"] as! String == "deliver" ? parameters["receiverPhone"] as! String : "",categoryAr: parameters["type"] as! String == "deliver" ? "" : parameters["categoryAr"] as! String,categoryEn: parameters["type"] as! String == "deliver" ? "" : parameters["categoryEn"] as! String,recommendedPlaces: parameters["type"] as! String == "deliver" ? "" : parameters["recommendedPlace"] as! String, productImgUrl: parameters["image"] as! String, description: parameters["description"] as! String, type: parameters["type"] as! String, clientPhone: (parameters["client"] as! NSDictionary)["phone"] as! String,clientId: parameters["clientId"] as! String)
                
                    MainContainerViewController.driver.setOrder(order)
                
                    MainContainerViewController.driver.status = .newOrderReceived
                }
            case "orderAlreadyAccepted":
                centerViewController.orderAlreadyAccepted()
            case "anotherDriverSelected":
                centerViewController.anotherDriverSelected()
            case "suggestionAccepted":
                centerViewController.suggestionAccepted()
            case "messageReceived":
                centerViewController.messageReceived(parameters["message"] as! String,type: parameters["messageType"] as! Int)
            case "tripReview":
                break
            case "clientCancelTrip":
                centerViewController.clientCancelledTrip()
            case "currentTripDetails":
                let clientData = parameters["client"] as! NSDictionary
                let type = parameters["type"] as! String
                MainContainerViewController.driver.setOrder(Order(id: parameters["orderId"] as! String, fromLat: parameters["fromLatitude"] as! Double, fromLng: parameters["fromLongitude"] as! Double, fromAddress: parameters["fromAddress"] as! String, toLat: parameters["toLatitude"] as! Double, toLng: parameters["toLongitude"] as! Double, toAddress: parameters["toAddress"] as! String, amount: parameters["amount"] as! String, receiverName: type == "bring" ? "" : parameters["receiverName"] as! String, receiverPhone: type == "bring" ? "" : parameters["receiverPhone"] as! String, categoryAr: type == "bring" ? parameters["categoryAr"] as! String : "", categoryEn: type == "bring" ? parameters["categoryEn"] as! String : "", recommendedPlaces: type == "bring" ? parameters["recommendedPlace"] as! String : "", productImgUrl: parameters["image"] as! String, description: parameters["description"] as! String, type: type, clientPhone: clientData["phone"] as! String, clientId: parameters["clientId"] as! String))
                MainContainerViewController.driver.setStatus(.inTrip)
                centerViewController.inTripStarted()
                if parameters["isTripStarted"] as! Bool {
                    centerViewController.startTripNow()
                }
                let coordinates = parameters["coordinates"] as! NSArray
            
                var currentCoordinates,lastCoordinate: CLLocationCoordinate2D!
                
                for index in 0..<coordinates.count {
                    if index == 0 {
                        lastCoordinate = CLLocationCoordinate2D(latitude: (coordinates[index] as! NSDictionary)["lat"] as! Double, longitude: (coordinates[index] as! NSDictionary)["lng"] as! Double)
                    } else {
                        currentCoordinates = CLLocationCoordinate2D(latitude: (coordinates[index] as! NSDictionary)["lat"] as! Double, longitude: (coordinates[index] as! NSDictionary)["lng"] as! Double)
                        centerViewController.drawRoute(currentCoordinates, endLocation: lastCoordinate)
                        lastCoordinate = currentCoordinates
                    }
                }
            case "getDriverInvoice":
                let inviceVC = UIStoryboard(name: "PopUps", bundle: nil).instantiateViewController(withIdentifier: "invoice") as! InvoiceViewController
                inviceVC.contents.append(parameters["totalFee"] as! String)
                inviceVC.contents.append(parameters["type"] as! String)
                inviceVC.contents.append(parameters["promotion"] as! String)
                inviceVC.contents.append(parameters["ourProfit"] as! String)
                inviceVC.contents.append(parameters["yourProfit"] as! String)
                DialogsHelper.getInstance().showPopUp(centerViewController, popUp: inviceVC)
            default:
                break
            }
        }
}

// MARK: CenterViewController delegate

extension MainContainerViewController: CenterViewControllerDelegate {
    
    func toggleLeftPanel() {
        let notAlreadyExpanded = (currentState != .leftPanelExpanded)
        
        if notAlreadyExpanded {
            addLeftPanelViewController()
        }
        
        animateLeftPanel(notAlreadyExpanded)
    }
    
    func toggleRightPanel() {
        
        let notAlreadyExpanded = (currentState != .rightPanelExpanded)
        
        if notAlreadyExpanded {
            addRightPanelViewController()
        }
        
        animateRightPanel(notAlreadyExpanded)
    }
    
    func collapseSidePanels() {        
        switch (currentState) {
        case .rightPanelExpanded:
            toggleRightPanel()
        case .leftPanelExpanded:
            toggleLeftPanel()
        default:
            break
        }
    }
    
    func addLeftPanelViewController() {
        if (leftViewController == nil) {
            leftViewController = UIStoryboard.leftViewController()
            
            addChildSidePanelController(leftViewController!)
        }
    }
    
    func addChildSidePanelController(_ sidePanelController: SidePanelViewController) {
        sidePanelController.delegate = centerViewController
        
        view.insertSubview(sidePanelController.view, at: 0)
        
        addChildViewController(sidePanelController)
        sidePanelController.didMove(toParentViewController: self)
    }
    
    
    func addRightPanelViewController() {
        if (rightViewController == nil) {
            rightViewController = UIStoryboard.rightViewController()
            
            addChildSidePanelController(rightViewController!)
        }
    }
    
    
    func animateLeftPanel(_ shouldExpand: Bool) {
        if (shouldExpand) {
            currentState = .leftPanelExpanded
            
            animateCenterPanelXPosition(centerNavigationController.view.frame.width - centerPanelExpandedOffset)
        } else {
            animateCenterPanelXPosition(0) { finished in
                self.currentState = .bothCollapsed
                
                self.leftViewController!.view.removeFromSuperview()
                self.leftViewController = nil;
            }
        }
    }
    
    
    func animateCenterPanelXPosition(_ targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions(), animations: {
            self.centerNavigationController.view.frame.origin.x = targetPosition
        }, completion: completion)
    }
    
    func showShadowForCenterViewController(_ shouldShowShadow: Bool) {
        if (shouldShowShadow) {
            centerNavigationController.view.layer.shadowOpacity = 0.8
        } else {
            centerNavigationController.view.layer.shadowOpacity = 0.0
        }
    }
    
    func animateRightPanel(_ shouldExpand: Bool) {
        if (shouldExpand) {
            currentState = .rightPanelExpanded
            
            animateCenterPanelXPosition(-centerNavigationController.view.frame.width + centerPanelExpandedOffset)
        } else {
            animateCenterPanelXPosition(0) { _ in
                self.currentState = .bothCollapsed
                
                self.rightViewController!.view.removeFromSuperview()
                self.rightViewController = nil;
            }
        }
    }
    
    func showProfile() {
        performSegue(withIdentifier: "showProfile", sender: self)
    }
    
    func showOrdersHistory() {
        performSegue(withIdentifier: "showOrdersHistory", sender: self)
    }
    
    func showProfit() {
        performSegue(withIdentifier: "showProfit", sender: self)
    }
    
    func changeLanguage() {
        DialogsHelper.getInstance().showAlertDialog(MainViewController.instance, title: LanguageHelper.getStringLocalized("language"), message: LanguageHelper.getStringLocalized("change_language_confirm"), completion: { userAction in
            if userAction {
                LanguageHelper.setCurrentLanguage(LanguageHelper.getCurrentLanguage() == "ar" ? "en" : "ar")
                self.present(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainNav"), animated: true, completion: nil)
            }
        })
    }
    
}

extension MainContainerViewController: UIGestureRecognizerDelegate {
    // MARK: Gesture recognizer
    
    func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let gestureIsDraggingFromLeftToRight = (recognizer.velocity(in: view).x > 0)
        
        switch(recognizer.state) {
        case .began:
            if (currentState == .bothCollapsed) {
                if (gestureIsDraggingFromLeftToRight && LanguageHelper.getCurrentLanguage() == "en") {
                    addLeftPanelViewController()
                } else if (!gestureIsDraggingFromLeftToRight && LanguageHelper.getCurrentLanguage() == "ar") {
                    addRightPanelViewController()
                }
                
                showShadowForCenterViewController(true)
            }
        case .changed:
            recognizer.view!.center.x = recognizer.view!.center.x + recognizer.translation(in: view).x
            recognizer.setTranslation(CGPoint.zero, in: view)
        case .ended:
            if (leftViewController != nil) {
                // animate the side panel open or closed based on whether the view has moved more or less than halfway
                let hasMovedGreaterThanHalfway = recognizer.view!.center.x > view.bounds.size.width
                animateLeftPanel(hasMovedGreaterThanHalfway)
            } else if (rightViewController != nil) {
                let hasMovedGreaterThanHalfway = recognizer.view!.center.x < 0
                animateRightPanel(hasMovedGreaterThanHalfway)
            } else {
                 animateCenterPanelXPosition(0)
            }
        default:
            break
        }
    }
    
}

private extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: Bundle.main) }
    
    class func rightViewController() -> SidePanelViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "rightViewController") as? SidePanelViewController
    }
    
    class func leftViewController() -> SidePanelViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "leftViewController") as? SidePanelViewController
    }
    
    class func centerViewController() -> MainViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "MainViewController") as? MainViewController
    }
    
}
