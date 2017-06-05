import UIKit
import SystemConfiguration

class Request {

    var indicator: UIActivityIndicatorView!
    var indicatorView: UIView!
    
    fileprivate static var instance : Request!
    
    static func getInstance() -> Request {
        if instance == nil {
            instance = Request()
        }
        return instance
    }
    
    func post(_ url: String,params: String,view: UIViewController,completion: @escaping (_ data: NSDictionary)->Void) {
        if isConnected() {
            view.view.isUserInteractionEnabled = false
            showLoadingDialog(view)
            let request = NSMutableURLRequest(url: URL(string: url)! as URL)
            request.httpMethod = "POST"
            
//            do {
//                let jsonData = try JSONSerialization.data(withJSONObject: ["username":"w","password":"w"], options: .prettyPrinted)
//                request.httpBody = jsonData
//            } catch {
//                print(error.localizedDescription)
//            }
            
            request.httpBody = params.data(using: .utf8)
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                guard error == nil && data != nil else {
                    self.removeLoadingDialog()
                    DialogsHelper.getInstance().showBottomAlert("An error has been occured",view: view)
                    DispatchQueue.main.async{
                        view.view.isUserInteractionEnabled = true
                    }
                    return
                }

                do {
                    let myJson =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary

                    self.removeLoadingDialog()
                    
                        if myJson?["result"] as! Bool {
                            DispatchQueue.main.async{
                                completion(myJson?["data"] as! NSDictionary)
                                view.view.isUserInteractionEnabled = true
                            }
                        } else {
                            DialogsHelper.getInstance().showBottomAlert(myJson?["message"] as! String, view: view)
                            DispatchQueue.main.async{
                                view.view.isUserInteractionEnabled = true
                            }
                        }
                

                } catch {
                    print(error.localizedDescription)
                    self.removeLoadingDialog()
                    DialogsHelper.getInstance().showBottomAlert("Sorry,An error has been occured",view: view)
                    DispatchQueue.main.async{
                        view.view.isUserInteractionEnabled = true
                    }
                }
            }
            task.resume()
            } else {
                DialogsHelper.getInstance().showBottomAlert(LanguageHelper.getStringLocalized("check_internet"),view: view)
            }
    }
    
    
    func get(_ url: String,view: UIViewController,completion: @escaping (_ data: NSDictionary)->Void) {
        if isConnected() {
            view.view.isUserInteractionEnabled = false
            showLoadingDialog(view)
            let request = NSMutableURLRequest(url: URL(string: url)! as URL)
            request.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                guard error == nil && data != nil else {
                    self.removeLoadingDialog()
                    DialogsHelper.getInstance().showBottomAlert("An error has been occured",view: view)
                    DispatchQueue.main.async{
                        view.view.isUserInteractionEnabled = true
                    }
                    return
                }
                
                do {
                    let myJson =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    
                    self.removeLoadingDialog()
                    
                    
                    if myJson?["result"] as! Bool {
                        DispatchQueue.main.async{
                            completion(myJson?["data"] as! NSDictionary)
                            view.view.isUserInteractionEnabled = true
                        }
                    } else {
                        DialogsHelper.getInstance().showBottomAlert(myJson?["message"] as! String, view: view)
                        DispatchQueue.main.async{
                            view.view.isUserInteractionEnabled = true
                        }
                    }
                    
                } catch {
                    self.removeLoadingDialog()
                    DialogsHelper.getInstance().showBottomAlert("Sorry,An error has been occured",view: view)
                    DispatchQueue.main.async{
                        view.view.isUserInteractionEnabled = true
                    }
                }
            }
            task.resume()
        } else {
            DialogsHelper.getInstance().showBottomAlert(LanguageHelper.getStringLocalized("check_internet"),view: view)
        }
    }
    
    func getWithOutUIDialogs(_ url: String,completion: @escaping (_ data: NSDictionary)->Void) {
        if isConnected() {
            let request = NSMutableURLRequest(url: URL(string: url)! as URL)
            request.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                guard error == nil && data != nil else {
                    return
                }
                
                do {
                    let myJson =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    
                    if myJson?["result"] as! Bool {
                        DispatchQueue.main.async{
                            completion(myJson?["data"] as! NSDictionary)
                        }
                    } else {
                        print(myJson?["message"] as! String)
                    }
                    
                } catch {
                    print(error.localizedDescription)
                }
            }
            task.resume()
        }
    }
    
    func getWithParameters(_ url: String,params: String,view: UIViewController,completion: @escaping (_ data: NSDictionary)->Void) {
        if isConnected() {
            view.view.isUserInteractionEnabled = false
            showLoadingDialog(view)
            let request = NSMutableURLRequest(url: URL(string: url)! as URL)
            request.httpMethod = "GET"
            
            //            do {
            //                let jsonData = try JSONSerialization.data(withJSONObject: ["username":"w","password":"w"], options: .prettyPrinted)
            //                request.httpBody = jsonData
            //            } catch {
            //                print(error.localizedDescription)
            //            }
            
            
            request.httpBody = params.data(using: .utf8)
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                guard error == nil && data != nil else {
                    self.removeLoadingDialog()
                    DialogsHelper.getInstance().showBottomAlert("An error has been occured",view: view)
                    DispatchQueue.main.async{
                        view.view.isUserInteractionEnabled = true
                    }
                    return
                }
                
                do {
                    let myJson =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    
                    self.removeLoadingDialog()
                    
                    if myJson?["result"] as! Bool {
                        DispatchQueue.main.async{
                            completion(myJson?["data"] as! NSDictionary)
                            view.view.isUserInteractionEnabled = true
                        }
                    } else {
                        DialogsHelper.getInstance().showBottomAlert(myJson?["message"] as! String, view: view)
                        DispatchQueue.main.async{
                            view.view.isUserInteractionEnabled = true
                        }
                    }
                    
                    
                } catch {
                    self.removeLoadingDialog()
                    DialogsHelper.getInstance().showBottomAlert("An error has been occured",view: view)
                    DispatchQueue.main.async{
                        view.view.isUserInteractionEnabled = true
                    }
                }
            }
            task.resume()
        } else {
            DialogsHelper.getInstance().showBottomAlert(LanguageHelper.getStringLocalized("check_internet"),view: view)
        }
    }
    
    
    func isConnected() -> Bool {
        let host = "http://google.com"
        
        let reachability = SCNetworkReachabilityCreateWithName(nil, host)!
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(reachability, &flags) {
            print("false")
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return isReachable && !needsConnection
    }
    
    
    func showLoadingDialog(_ view: UIViewController) {
        
        indicatorView = UIView(frame: CGRect(x: view.view.frame.width/2-75, y: view.view.frame.height/2-75, width: 150, height: 150))
        
        indicatorView.backgroundColor = UIColor(white: 0.0, alpha: 0.7)
        
        indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        indicator.frame = CGRect(x: indicatorView.frame.width/2-20,y: indicatorView.frame.height/2-40,width: 40, height: 40);
        
        indicatorView.addSubview(indicator)
        
        let loading = UILabel()
        
        loading.textColor = UIColor.white
        loading.text = LanguageHelper.getStringLocalized("please_wait")
        loading.textAlignment = .center
        loading.frame = CGRect(x: indicatorView.frame.width/2-60,y: indicatorView.frame.height/2+20,width: 120,height: 40)
        
        indicatorView.addSubview(loading)
        
        indicatorView.layer.cornerRadius = 10
        indicatorView.clipsToBounds = true
        
        indicator.startAnimating()
        view.view.addSubview(indicatorView)

    }
    
    func removeLoadingDialog() {
        DispatchQueue.main.async{
            self.indicator.stopAnimating()
            self.indicatorView.removeFromSuperview()
        }
    }

}


