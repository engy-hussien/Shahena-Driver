//
//  MainViewController.swift
//  MandobiDriver
//
//  Created by ِAmr on 1/19/17.
//  Copyright © 2017 Applexicon. All rights reserved.
//

import UIKit
import MapKit
import AVFoundation
import SwiftyGif

@objc
protocol CenterViewControllerDelegate {
    @objc optional func toggleLeftPanel()
    @objc optional func toggleRightPanel()
    @objc optional func collapseSidePanels()
    @objc optional func showProfile()
    @objc optional func showOrdersHistory()
    @objc optional func showProfit()
    @objc optional func changeLanguage()
}

@objc
protocol TimerDelegate {
    @objc optional func timerUpdate()
    @objc optional func timerFinished()
}

@objc
protocol LoadingDelegate {
    @objc optional func suggestionApproved()
    @objc optional func suggestionDisapproved()
    @objc optional func tripAlreadyAccepted()
    @objc optional func tripCompleted()
}

@objc
protocol MessageReceivedDelegate {
    @objc optional func messageReceived(_ message: String,type: Int)
    @objc optional func dismissMessages()
}

class MainViewController: LocalizationOrientedViewController , UIPopoverPresentationControllerDelegate , CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var fab: UIButton!
    @IBOutlet weak var locationBtn: UIButton!
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var messageBtn: UIButton!
    @IBOutlet weak var infoBtn: UIButton!
    @IBOutlet weak var startTrip: UIButton!
    @IBOutlet weak var routeBtn: UIButton!
    
    static var instance: MainViewController!
    
    var isFabPressed = false
    
    var timer : Timer!
    var counter = 0
    var timerDelegate: TimerDelegate!
    
    var loadingDelegate : LoadingDelegate!
    
    var messageDelegate: MessageReceivedDelegate!
    
    var delegate: CenterViewControllerDelegate?
    
    let regionRadius: CLLocationDistance = 1000
    
    var locationManager = CLLocationManager()
    
    var shouldShowCurrentLocation = true
    
    var currentLocation: CLLocation!
    
    var shouldStartTrip = false
    
    var driverCurrentAnnotation,startingAnnotation,sourceAnnotation,destinationAnnotation: MKAnnotation!
    
    var fabMessageCount,msgBtnMessageCount: UILabel!
    
    var messageIsShown = false
    
    var notSeenMessagesCount = 0
    
    var player: AVAudioPlayer?
    
    var gifImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        MainViewController.instance = self
        mapView.delegate = self
        prepareFab()
        prepareLocationBtns()
        prepareStartBtn()
        prepareBtnsForFabPressed()
    }
    
    func centerMapOnLocation(_ location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showCurrentLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = locations.first!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        if MainContainerViewController.driver.status == .inTrip && currentLocation != nil && currentLocation != locations.first {
            drawRoute(currentLocation.coordinate, endLocation: locValue)
        }
        currentLocation = locations.first
        if shouldShowCurrentLocation {
            if MainContainerViewController.driver.status != .inTrip {
                shouldShowCurrentLocation = false
            } else {
                if driverCurrentAnnotation != nil {
                    mapView.removeAnnotation(driverCurrentAnnotation)
                }
                driverCurrentAnnotation = MapPin(title: "", locationName: "", coordinate: locValue,type: "car")
                
                mapView.showAnnotations([driverCurrentAnnotation], animated: true)
            }
            centerMapOnLocation(manager.location!)
        }
        
        if UserData.getDriverToken() != nil {
            SocketIOController.emitEvent(SocketEvents.UPDATE_DRIVER_LOCATION, withParameters: ["connToken":UserData.getDriverToken() as AnyObject,"lat":locValue.latitude as AnyObject,"lng":locValue.longitude as AnyObject])
        }
        
//        getAddressFromCoordinates(coordinates: locValue)
    }
    
    func showCurrentLocation() {
        checkLocationAuthorizationStatus()
        mapView.showsUserLocation = true

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
//        mapView.showsUserLocation = false
    }
    
    func drawRoute(_ startLocation: CLLocationCoordinate2D,endLocation: CLLocationCoordinate2D) {
        
        let coordinates = [startLocation,endLocation]
        let polyline = MKPolyline(coordinates: coordinates, count: 2)
        
        
        if MainContainerViewController.driver.status == .inTrip {
            mapView.add(polyline, level: .aboveRoads)
        }
        
//        let sourcePlacemark = MKPlacemark(coordinate: startLocation, addressDictionary: nil)
//        let destinationPlacemark = MKPlacemark(coordinate: endLocation, addressDictionary: nil)
//        
//        
//        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
//        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
//        
//        let directionRequest = MKDirectionsRequest()
//        directionRequest.source = sourceMapItem
//        directionRequest.destination = destinationMapItem
//        directionRequest.transportType = .automobile
//        
//        
//        let directions = MKDirections(request: directionRequest)
//        
//        
//        directions.calculate {
//            (response, error) -> Void in
//            
//            guard let response = response else {
//                if let error = error {
//                    print("Error: \(error)")
//                }
//                
//                return
//            }
//            
//            let route = response.routes[0]
//            if route.distance < 300 && MainContainerViewController.driver.status == .inTrip {
//                self.mapView.add(route.polyline, level: .aboveRoads)
//                self.drawenRoutes.append(route.polyline)
//            }
//        }
        
    }
    
    func getAddressFromCoordinates(_ coordinates: CLLocationCoordinate2D) {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
//            // Address dictionary
//            print(placeMark.addressDictionary)
//            
            // Location name
            if let locationName = placeMark.addressDictionary!["Name"] as? NSString {
                print("locationName \(locationName)")
            }
            
            // Street address
//            if let street = placeMark.addressDictionary!["Thoroughfare"] as? NSString {
//                print(street)
//            }
            
//            // City
//            if let city = placeMark.addressDictionary!["City"] as? NSString {
//                print(city)
//            }
//            
//            // Zip code
//            if let zip = placeMark.addressDictionary!["ZIP"] as? NSString {
//                print(zip)
//            }
//            
//            // Country
//            if let country = placeMark.addressDictionary!["Country"] as? NSString {
//                print(country)
//            }
            
        })
    }

    
    func prepareFab() {
        fab.layer.cornerRadius = 0.5 * fab.bounds.size.width
        fab.clipsToBounds = true
        
        fab.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        fab.layer.shadowOffset = CGSize(width: 0.0,height: 2.0)
        fab.layer.shadowOpacity = 1.0
        fab.layer.shadowRadius = 1.0
        fab.layer.masksToBounds = false
        
        fabMessageCount = UILabel()
        
        fabMessageCount.frame = CGRect(x: 5, y: 5, width: 20, height: 20)
        fabMessageCount.textColor = UIColor.white
        fabMessageCount.backgroundColor = .red
        fabMessageCount.text = "0"
        fabMessageCount.layer.cornerRadius = 10
        fabMessageCount.clipsToBounds = true
        fabMessageCount.textAlignment = .center
        fabMessageCount.isHidden = true
        
        fab.addSubview(fabMessageCount)
    }
    
    func prepareLocationBtns() {
        locationBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        locationBtn.layer.shadowOffset = CGSize(width: 0.0,height: 1.5)
        locationBtn.layer.shadowOpacity = 1.0
        locationBtn.layer.shadowRadius = 2.0
        locationBtn.layer.masksToBounds = false
        locationBtn.layer.cornerRadius = 4.0
        
        routeBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        routeBtn.layer.shadowOffset = CGSize(width: 0.0,height: 1.5)
        routeBtn.layer.shadowOpacity = 1.0
        routeBtn.layer.shadowRadius = 2.0
        routeBtn.layer.masksToBounds = false
        routeBtn.layer.cornerRadius = 4.0
    }
    
    func prepareStartBtn() {
        startTrip.layer.cornerRadius = 0.5 * startTrip.bounds.size.width
        startTrip.clipsToBounds = true
        
        startTrip.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        startTrip.layer.shadowOffset = CGSize(width: 0.0,height: 2.0)
        startTrip.layer.shadowOpacity = 1.0
        startTrip.layer.shadowRadius = 1.0
        startTrip.layer.masksToBounds = false
        
        startTrip.setTitle(LanguageHelper.getStringLocalized("start"), for: .normal)
    }
    
    func prepareBtnsForFabPressed() {
        callBtn.layer.cornerRadius = 0.5 * callBtn.bounds.size.width
        callBtn.clipsToBounds = true
        
        messageBtn.layer.cornerRadius = 0.5 * messageBtn.bounds.size.width
        messageBtn.clipsToBounds = true
        
        infoBtn.layer.cornerRadius = 0.5 * infoBtn.bounds.size.width
        infoBtn.clipsToBounds = true
        
        msgBtnMessageCount = UILabel()
        
        msgBtnMessageCount.frame = CGRect(x: 5, y: 5, width: 20, height: 20)
        msgBtnMessageCount.textColor = UIColor.white
        msgBtnMessageCount.backgroundColor = .red
        msgBtnMessageCount.text = "0"
        msgBtnMessageCount.layer.cornerRadius = 10
        msgBtnMessageCount.clipsToBounds = true
        msgBtnMessageCount.textAlignment = .center
        msgBtnMessageCount.isHidden = true
        
        messageBtn.addSubview(msgBtnMessageCount)
    }
    
    func inTripStarted() {
        shouldShowCurrentLocation = true
        darkenFab()
        if currentLocation != nil {
            centerMapOnLocation(currentLocation)
        } else {
            showCurrentLocation()
        }
        shouldStartTrip = true
        startTrip.isHidden = false
        mapView.showsUserLocation = false
        
        routeBtn.isHidden = false
        
        startingAnnotation = MapPin(title: "", locationName: "", coordinate: currentLocation.coordinate,type: "pin")
        
        if let _ = MainContainerViewController.driver.getOrder() {
        sourceAnnotation = MapPin(title: MainContainerViewController.driver.getOrder().getFromAddress(), locationName: MainContainerViewController.driver.getOrder().getFromAddress(), coordinate: CLLocationCoordinate2D(latitude: MainContainerViewController.driver.getOrder().getFromLat(), longitude: MainContainerViewController.driver.getOrder().getFromLng()),type: "pin")
        
        destinationAnnotation = MapPin(title: MainContainerViewController.driver.getOrder().getToAddress(), locationName: MainContainerViewController.driver.getOrder().getToAddress(), coordinate: CLLocationCoordinate2D(latitude: MainContainerViewController.driver.getOrder().getToLat(), longitude: MainContainerViewController.driver.getOrder().getToLng()),type: "pin")
        
        mapView.showAnnotations([startingAnnotation,sourceAnnotation,destinationAnnotation], animated: true)
        }
        
    }
    
    func orderAlreadyAccepted() {
        if MainContainerViewController.driver.status == .inTrip {
            clearTrip()
        } else if MainContainerViewController.driver.status == .newOrderReceived {
            if view.subviews.contains(gifImageView) {
                gifImageView.removeFromSuperview()
                player?.stop()
            } else {
               presentedViewController?.dismiss(animated: true, completion: nil)
                lightenFab()
            }
            MainContainerViewController.driver.status = .free
            stopTimer()
        }
        
        let deadlineTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            
            DialogsHelper.getInstance().showAlertDialogWithOnlyOk(self, title: nil, message: LanguageHelper.getStringLocalized("tripAlertAccpeted"), completion: { (data) in
                
            })
        })
    }
    
    func anotherDriverSelected() {
        self.loadingDelegate.suggestionDisapproved!()
        MainContainerViewController.driver.status = .free
    }
    
    func suggestionAccepted() {
        stopTimer()
        MainContainerViewController.driver.status = .inTrip
        self.loadingDelegate.suggestionApproved!()
//        startTripNow()
    }
    
    func darkenFab() {
        UIView.animate(withDuration: 0.5, animations: {
            self.fab.alpha = 1
        })
    }
    
    func lightenFab() {
        UIView.animate(withDuration: 0.5, animations: {
            self.fab.alpha = 0.5
        })
    }
    
    func newOrderReceived() {
        let gifmanager = SwiftyGifManager(memoryLimit:20)
        let gif = UIImage(gifName: "notifications")
        gifImageView = UIImageView(gifImage: gif, manager: gifmanager)
        gifImageView.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: view.frame.height)
        gifImageView.isUserInteractionEnabled = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(stopGif))
        gifImageView.addGestureRecognizer(tapGestureRecognizer)
        
        view.addSubview(gifImageView)
        
        counter = 29
        darkenFab()
        startTimer()
        playSound()
    }
    
    func stopGif() {
        gifImageView.removeFromSuperview()
        DialogsHelper.getInstance().showPopUp(self, popUp: UIStoryboard(name: "PopUps", bundle: nil).instantiateViewController(withIdentifier: "newOrder"))
        player?.stop()
    }
    
    func waitForSuggestionResponse() {
        DialogsHelper.getInstance().showPopUp(self, popUp: UIStoryboard(name: "PopUps", bundle: nil).instantiateViewController(withIdentifier: "loading"))
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(MainViewController.updateTimer), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }
    
    func updateTimer() {
        print(counter)
        if counter > 0 {
            counter -= 1
            if timerDelegate != nil {
                timerDelegate.timerUpdate!()
            }
        } else {
            if gifImageView != nil {
                gifImageView.removeFromSuperview()
            }
            stopTimer()
            if timerDelegate != nil {
                timerDelegate.timerFinished!()
            }
            MainContainerViewController.driver.status = .free
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    
    func addBtnsForFabAction() {
        isFabPressed = true
        
        UIView.animate(withDuration: 0.5, animations: {
            self.callBtn.alpha = 1
            self.messageBtn.alpha = 1
            self.infoBtn.alpha = 1
            
            self.callBtn.center.y -= 80
            self.messageBtn.center.y -= 160
            self.infoBtn.center.y -= 240
        })
    }
    
    func removeBtnsForFabAction() {
        isFabPressed = false
        UIView.animate(withDuration: 0.5, animations: {
            self.callBtn.center.y += 80
            self.messageBtn.center.y += 160
            self.infoBtn.center.y += 240
            
            self.callBtn.alpha = 0
            self.messageBtn.alpha = 0
            self.infoBtn.alpha = 0
        })
    }
    
    func showMessgaes() {
        notSeenMessagesCount = 0
        msgBtnMessageCount.isHidden = true
        fabMessageCount.isHidden = true
        messageIsShown = true
        UIView.animate(withDuration: 1, delay: 0.5, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
            self.fab.center.y = 110
        }, completion: {_ in
            DialogsHelper.getInstance().showPopUpWithArrow(self, popUp: UIStoryboard(name: "PopUps", bundle: nil).instantiateViewController(withIdentifier: "message"), arrowX: self.fab.center.x, arrowY: 150)
        })
    }
    
    func messagesDisappeared() {
        messageIsShown = false
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
            self.fab.center.y = self.view.frame.maxY - 50
        }, completion: nil)
    }
    
    func messageReceived(_ message: String,type: Int) {
        MainContainerViewController.driver.getOrder().addMessage(Message(senderType: "client",type: type, message: message, time: ""))
        if isFabPressed {
            notSeenMessagesCount += 1
            msgBtnMessageCount.isHidden = false
            fabMessageCount.isHidden = true
            msgBtnMessageCount.text = "\(notSeenMessagesCount)"
            bloat(msgBtnMessageCount)
        } else if messageIsShown {
            notSeenMessagesCount = 0
            msgBtnMessageCount.isHidden = true
            fabMessageCount.isHidden = true
            if messageDelegate != nil{
                messageDelegate.messageReceived!(message,type: type)
            }
        } else {
            notSeenMessagesCount += 1
            msgBtnMessageCount.isHidden = true
            fabMessageCount.isHidden = false
            fabMessageCount.text = "\(notSeenMessagesCount)"
            bloat(fabMessageCount)
        }
    }
    
    func showInfo() {
        DialogsHelper.getInstance().showPopUp(self, popUp: UIStoryboard(name: "PopUps", bundle: nil).instantiateViewController(withIdentifier: "info"))
    }
    
    func bloat(_ view: UIView) {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = NSNumber(value: 1.5 as Float)
        animation.duration = 0.3
        animation.repeatCount = 1.0
        animation.autoreverses = true
        view.layer.add(animation, forKey: nil)
    }
    
    @IBAction func fabBtnAction(_ sender: Any) {
        switch MainContainerViewController.driver.status {
        case .inTrip:
            if isFabPressed {
                removeBtnsForFabAction()
                if notSeenMessagesCount > 0 {
                    msgBtnMessageCount.isHidden = true
                    fabMessageCount.text = "\(notSeenMessagesCount)"
                    fabMessageCount.isHidden = false
                } else {
                    fabMessageCount.isHidden = true
                    msgBtnMessageCount.isHidden = true
                    
                }
            } else {
                addBtnsForFabAction()
                if notSeenMessagesCount > 0 {
                    fabMessageCount.isHidden = true
                    msgBtnMessageCount.text = "\(notSeenMessagesCount)"
                    msgBtnMessageCount.isHidden = false
                } else {
                    fabMessageCount.isHidden = true
                    msgBtnMessageCount.isHidden = true
                }
            }
        case .newOrderReceived:
            DialogsHelper.getInstance().showPopUp(self, popUp: UIStoryboard(name: "PopUps", bundle: nil).instantiateViewController(withIdentifier: "newOrder"))
        default:
            break
        }
        
    }
    
    @IBAction func currentLocationAction(_ sender: Any) {
        if currentLocation != nil {
            centerMapOnLocation(currentLocation)
        } else {
            shouldShowCurrentLocation = true
            showCurrentLocation()
        }
    }
    
    @IBAction func routeAction(_ sender: Any) {
        
        let regionDistance:CLLocationDistance = 10000
        var coordinates: CLLocationCoordinate2D!
        
        if shouldStartTrip {
            coordinates = CLLocationCoordinate2DMake(MainContainerViewController.driver.getOrder().getFromLat(), MainContainerViewController.driver.getOrder().getFromLng())
        } else {
            coordinates = CLLocationCoordinate2DMake(MainContainerViewController.driver.getOrder().getToLat(), MainContainerViewController.driver.getOrder().getToLng())
        }
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = MainContainerViewController.driver.getOrder().getToAddress()
        mapItem.openInMaps(launchOptions: options)
    }
    
    @IBAction func callBtnPressed(_ sender: Any) {
        removeBtnsForFabAction()
        
        if MainContainerViewController.driver.getOrder().getType() == "deliver" {
            DialogsHelper.getInstance().showSmallPopUp(self, popUp: UIStoryboard(name: "PopUps", bundle: nil).instantiateViewController(withIdentifier: "phoneList"))
        } else {
            let url = URL(string: "telprompt://\(MainContainerViewController.driver.getOrder().getClientPhone())")!
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    @IBAction func messageBtnPressed(_ sender: Any) {
        removeBtnsForFabAction()
        showMessgaes()
    }
    @IBAction func infoBtnPressed(_ sender: Any) {
        removeBtnsForFabAction()
        showInfo()
    }
    @IBAction func startTripAction(_ sender: Any) {
        if shouldStartTrip {
            startTripNow()
        } else {
            SocketIOController.emitEvent(SocketEvents.END_TRIP, withParameters: ["connToken":UserData.getDriverToken() as AnyObject,"orderId":MainContainerViewController.driver.getOrder().getId() as AnyObject])
            
            mapView.removeAnnotations(mapView.annotations)
            
//            DialogsHelper.getInstance().showPopUp(self, popUp: UIStoryboard(name: "PopUps", bundle: nil).instantiateViewController(withIdentifier: "loading"))
//            
//            let deadlineTime = DispatchTime.now() + .seconds(1)
//            DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
//                self.loadingDelegate.tripCompleted!()
//            })
            
            clearTrip()
        }
    }
    
    func startTripNow() {
        SocketIOController.emitEvent(SocketEvents.START_TRIP, withParameters: ["connToken":UserData.getDriverToken() as AnyObject,"orderId":MainContainerViewController.driver.getOrder().getId() as AnyObject])
        shouldStartTrip = false
        startTrip.setTitle(LanguageHelper.getStringLocalized("finish"), for: .normal)
    }
    
    func clearTrip() {
        if messageIsShown {
            messageDelegate.dismissMessages!()
        }
        MainContainerViewController.driver.setOrder(nil)
        MainContainerViewController.driver.status = .free
        
        startTrip.setTitle(LanguageHelper.getStringLocalized("start"), for: .normal)
        startTrip.isHidden = true
        
        mapView.showsUserLocation = true
        
        if isFabPressed {
            removeBtnsForFabAction()
        }
        
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
        
        notSeenMessagesCount = 0
        
        routeBtn.isHidden = true
        
        notSeenMessagesCount = 0
        msgBtnMessageCount.isHidden = true
        fabMessageCount.isHidden = true
    }
    
    func clientCancelledTrip() {
        mapView.removeAnnotations(mapView.annotations)
        DialogsHelper.getInstance().showAlertDialogWithOnlyOk(self, title: nil, message: LanguageHelper.getStringLocalized("client_cancelled"), completion: {_ in })
        clearTrip()
    }
    
    func playSound() {
        let url = Bundle.main.url(forResource: "vast", withExtension: "mp3")!
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}

extension MainViewController: SidePanelViewControllerDelegate {
    func itemSelected(_ position: Int) {
        delegate?.collapseSidePanels?()
        switch position {
        case 0:
            delegate?.showProfile!()
        case 1:
            delegate?.showOrdersHistory!()
        case 2:
            delegate?.showProfit!()
        case 3:
            delegate?.changeLanguage!()
        default:
            break
        }
    }
}


extension MainViewController: MKMapViewDelegate {
        
        fileprivate func addAnnotation(_ coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = title
            annotation.subtitle = subtitle
            mapView.addAnnotation(annotation)
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation { return nil }
            
            let identifier = "CustomAnnotation"
            
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView!.canShowCallout = true
                   // go ahead and use forced unwrapping and you'll be notified if it can't be found; alternatively, use `guard` statement to accomplish the same thing and show a custom error message
            } else {
                annotationView!.annotation = annotation
            }
            
            annotationView!.image = UIImage(named: (annotation as! MapPin).type)!
            
            return annotationView
        }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 4.0
        
        return renderer
    }

    
}

