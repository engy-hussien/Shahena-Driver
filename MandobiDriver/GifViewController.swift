//
//  GifViewController.swift
//  MandobiDriver
//
//  Created by ِAmr on 2/27/17.
//  Copyright © 2017 Applexicon. All rights reserved.
//

import UIKit
import SwiftyGif

class GifViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gifmanager = SwiftyGifManager(memoryLimit:20)
        let gif = UIImage(gifName: "notifications")
        let gifImageView = UIImageView(gifImage: gif, manager: gifmanager)
        gifImageView.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: view.frame.height)
        gifImageView.isUserInteractionEnabled = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(stopGif))
        gifImageView.addGestureRecognizer(tapGestureRecognizer)
        
        view.addSubview(gifImageView)
    }
    
    
    func stopGif() {
        dismiss(animated: true, completion: nil)
    }
}
