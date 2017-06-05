//
//  SidePanelViewController.swift
//  MandobiDriver
//
//  Created by ِAmr on 1/19/17.
//  Copyright © 2017 Applexicon. All rights reserved.
//

import UIKit


protocol SidePanelViewControllerDelegate {
    func itemSelected(_ position: Int)
}


class SidePanelViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    var delegate: SidePanelViewControllerDelegate?

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!

    let tableNames = [LanguageHelper.getStringLocalized("my_profile"),
                       LanguageHelper.getStringLocalized("orders_history"),
                       LanguageHelper.getStringLocalized("profit"),
                       LanguageHelper.getStringLocalized("language")]
    let tableImages = ["userProfile","history","profit","language"]
    var images_cache = [String:UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userName.text = MainContainerViewController.driver.getName()
        tableView.delegate = self
        tableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        load_image(Links.URl_IMAGES + MainContainerViewController.driver.getImgUrl(), imageview: userImage)
    }
    func load_image(_ link:String, imageview:UIImageView){
        let url:URL = URL(string: link)!
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: url)
        request.timeoutInterval = 10
        let task = session.dataTask(with: url, completionHandler:
            { (data :Data?, response :URLResponse?, error:Error?) in
                guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                    return
                }
                var image = UIImage(data: data!)
                
                if (image != nil){
                    func set_image()
                    {
                        self.images_cache[link] = image
                        imageview.image = image
                    }
                    DispatchQueue.main.async(execute: set_image)
                }
        })
        
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sideCell") as! SideTableViewCell
        cell.lbl.text = tableNames[indexPath.row]
        cell.img.image = UIImage(named: tableImages[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.itemSelected(indexPath.row)
    }
}
