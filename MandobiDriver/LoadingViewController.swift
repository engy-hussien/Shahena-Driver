//
//  LoadingViewController.swift
//  MandobiDriver
//
//  Created by ِAmr on 1/27/17.
//  Copyright © 2017 Applexicon. All rights reserved.
//

import UIKit

class LoadingViewController: LocalizationOrientedViewController , LoadingDelegate {

    @IBOutlet weak var comleted: UIImageView!
    @IBOutlet weak var loading: UIImageView!
    @IBOutlet weak var approvalMessage: UILabel!
    
    var canAnimate = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MainViewController.instance.loadingDelegate = self
        approvalMessage.numberOfLines = 0
        approvalMessage.text = LanguageHelper.getStringLocalized("wait_approval")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animate()
    }
    
    func animate() {
        UIView.animate(withDuration: 0.12, delay: 0, options: [], animations: {
            self.loading.transform = CGAffineTransform(rotationAngle: -350)
        }, completion: {_ in
            UIView.animate(withDuration: 0.12, delay: 0, options: [], animations: {
                self.loading.transform = CGAffineTransform(rotationAngle: -700)
            }, completion: {_ in
                UIView.animate(withDuration: 0.12, delay: 0, options: [], animations: {
                    self.loading.transform = CGAffineTransform(rotationAngle: -1100)
                }, completion: {_ in
                    if self.canAnimate {
                        self.animate()
                    }
                })
            })
            
        })
    }
    
    func tripAlreadyAccepted() {
        canAnimate = false
        comleted.image = UIImage(named: "disapproved")
        UIView.animate(withDuration: 0.5, animations: {
            self.loading.alpha = 0
            self.comleted.alpha = 1
            self.approvalMessage.text = LanguageHelper.getStringLocalized("another_driver_accepted")
        },completion:{_ in
            let deadlineTime = DispatchTime.now() + .seconds(1)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
                self.dismiss(animated: true, completion: nil)
            })
        })
    }
    
    func tripCompleted() {
        canAnimate = false
        comleted.image = UIImage(named: "tripCompleted")
        UIView.animate(withDuration: 0.5, animations: {
            self.loading.alpha = 0
            self.comleted.alpha = 1
            self.approvalMessage.text = LanguageHelper.getStringLocalized("trip_completed")
        },completion:{_ in
            let deadlineTime = DispatchTime.now() + .seconds(1)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
                self.dismiss(animated: true, completion: nil)
            })
        })
    }
    
    func suggestionApproved() {
        canAnimate = false
        UIView.animate(withDuration: 0.5, animations: {
            self.loading.alpha = 0
            self.comleted.alpha = 1
            self.approvalMessage.text = LanguageHelper.getStringLocalized("approved")
        },completion:{_ in
                    let deadlineTime = DispatchTime.now() + .seconds(1)
                    DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
                        self.dismiss(animated: true, completion: nil)
                    })
        })
    }
    
    func suggestionDisapproved() {
        canAnimate = false
        comleted.image = UIImage(named: "disapproved")
        UIView.animate(withDuration: 0.5, animations: {
            self.loading.alpha = 0
            self.comleted.alpha = 1
            self.approvalMessage.text = LanguageHelper.getStringLocalized("disapproved")
        },completion:{_ in
            let deadlineTime = DispatchTime.now() + .seconds(1)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
                self.dismiss(animated: true, completion: nil)
            })
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        canAnimate = false
    }
    
}
