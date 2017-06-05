//
//  MessagesViewController.swift
//  MandobiDriver
//
//  Created by ِAmr on 2/8/17.
//  Copyright © 2017 Applexicon. All rights reserved.
//

import UIKit

class MessagesViewController: LocalizationOrientedViewController , UITableViewDelegate , UITableViewDataSource ,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var messageTxtField: UITextField!
    
    @IBOutlet weak var imageViewer: UIImageView!
    @IBOutlet weak var imageView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.isHidden = true
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
        
        messageTxtField.placeholder = LanguageHelper.getStringLocalized("type_msg")
        MainViewController.instance.messageDelegate = self
        
        messagesTableView.rowHeight = UITableViewAutomaticDimension
        messagesTableView.estimatedRowHeight = 999
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        MainViewController.instance.messagesDisappeared()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MainContainerViewController.driver.getOrder().getMessages().count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if MainContainerViewController.driver.getOrder().getMessages()[indexPath.row].type != 0{
      
            imageView.isHidden = false
            let data: Data = Data(base64Encoded: MainContainerViewController.driver.getOrder().getMessages()[indexPath.row].message , options: .ignoreUnknownCharacters)!
            // turn  Decoded String into Data
            let dataImage = UIImage(data: data as Data)
            imageViewer.image = dataImage
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell",
                                                 for: indexPath) as! MessageTableViewCell
        
        if MainContainerViewController.driver.getOrder().getMessages()[indexPath.row].senderType == "client" {
            cell.driverMessageTxt.isHidden = true
            cell.driverChatImage.isHidden = true
            if MainContainerViewController.driver.getOrder().getMessages()[indexPath.row].type == 0 {
                cell.clientMessageTxt.text = MainContainerViewController.driver.getOrder().getMessages()[indexPath.row].message
                cell.clientMessageTxt.layer.masksToBounds = true
                cell.clientMessageTxt.layer.cornerRadius = 5
                cell.clientChatImage.isHidden = true
                cell.clientMessageTxt.isHidden = false
            } else {
                let data: Data = Data(base64Encoded: MainContainerViewController.driver.getOrder().getMessages()[indexPath.row].message , options: .ignoreUnknownCharacters)!
                // turn  Decoded String into Data
                let dataImage = UIImage(data: data as Data)
                // pass the data image to image View.:)
                cell.clientChatImage.image = dataImage
                cell.clientMessageTxt.isHidden = true
                cell.clientChatImage.isHidden = false
            }
        } else {
            cell.clientMessageTxt.isHidden = true
            cell.clientChatImage.isHidden = true
            if MainContainerViewController.driver.getOrder().getMessages()[indexPath.row].type == 0 {
                cell.driverMessageTxt.text = MainContainerViewController.driver.getOrder().getMessages()[indexPath.row].message
                cell.driverMessageTxt.layer.masksToBounds = true
                cell.driverMessageTxt.layer.cornerRadius = 5
                cell.driverChatImage.isHidden = true
                cell.driverMessageTxt.isHidden = false
            } else {
                let data: Data = Data(base64Encoded: MainContainerViewController.driver.getOrder().getMessages()[indexPath.row].message , options: .ignoreUnknownCharacters)!
                // turn  Decoded String into Data
                let dataImage = UIImage(data: data as Data)
                // pass the data image to image View.:)
                cell.driverChatImage.image = dataImage
                cell.driverMessageTxt.isHidden = true
                cell.driverChatImage.isHidden = false
            }
        }
        
        return cell
    }
    
    @IBAction func sendAction(_ sender: Any) {
        if messageTxtField.text == "" {
            DialogsHelper.getInstance().showBottomAlert(LanguageHelper.getStringLocalized("write_msg"), view: self)
        } else {
            SocketIOController.emitEvent(SocketEvents.SEND_MESSAGE, withParameters: ["message":messageTxtField.text as AnyObject,"senderToken":UserData.getDriverToken() as AnyObject,"receiverToken":MainContainerViewController.driver.getOrder().getClientId() as AnyObject,"messageType" : 0 as AnyObject,"senderType": "driver" as AnyObject])
            MainContainerViewController.driver.getOrder().addMessage(Message(senderType: "driver",type: 0, message: messageTxtField.text!, time: ""))
            messageTxtField.text = ""
            messagesTableView.reloadData()
            
            self.messagesTableView.scrollToRow(at: IndexPath(row: MainContainerViewController.driver.getOrder().getMessages().count-1, section: 0), at: .top, animated: false)
        }
    }
    
    @IBAction func attachImageAction(_ sender: Any) {
        DialogsHelper.getInstance().takeImage(self, title: [LanguageHelper.getStringLocalized("image_alert_title"),LanguageHelper.getStringLocalized("camera"),LanguageHelper.getStringLocalized("photo_library"),LanguageHelper.getStringLocalized("image_alert_cancel")])
    }
    
    @IBAction func closePressed(_ sender: UIButton) {
        imageView.isHidden = true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        let imageData = UIImageJPEGRepresentation(selectedImage, 0)
        
        let str64 = imageData?.base64EncodedString(options: .lineLength64Characters)
        
        MainContainerViewController.driver.getOrder().addMessage(Message(senderType: "driver",type: 1, message: str64!, time: ""))
        
        SocketIOController.emitEvent(SocketEvents.SEND_MESSAGE, withParameters: ["message": str64 as AnyObject,"senderToken":UserData.getDriverToken() as AnyObject,"receiverToken":MainContainerViewController.driver.getOrder().getClientId() as AnyObject,"messageType" : 1 as AnyObject,"senderType": "driver" as AnyObject])
        
        messagesTableView.reloadData()
        self.dismiss(animated: true, completion: nil)
        
    }
    
}

extension MessagesViewController: MessageReceivedDelegate {
    
    func messageReceived(_ message: String,type: Int) {
        messagesTableView.reloadData()
        self.messagesTableView.scrollToRow(at: IndexPath(row: MainContainerViewController.driver.getOrder().getMessages().count-1, section: 0), at: .top, animated: false)
    }
    
    func dismissMessages() {
        dismiss(animated: true, completion: nil)
    }
}

