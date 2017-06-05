import UIKit

class DialogsHelper {
    
    fileprivate static var instance : DialogsHelper!
    
    static func getInstance() -> DialogsHelper {
        if instance == nil {
            instance = DialogsHelper()
        }
        return instance
    }
    
    func showPopUp(_ inViewController: UIViewController,popUp: UIViewController) {
        
        popUp.modalPresentationStyle = UIModalPresentationStyle.popover
        
        let popover = popUp.popoverPresentationController
        popUp.preferredContentSize = CGSize(width: 300,height: 400)
        popover?.delegate = inViewController as? UIPopoverPresentationControllerDelegate
        popover?.sourceView = inViewController.view
        popover?.sourceRect = CGRect(x: inViewController.view.bounds.midX, y: inViewController.view.bounds.midY, width: 0, height: 0)
        popover?.permittedArrowDirections = UIPopoverArrowDirection(rawValue:0)
        
        inViewController.present(popUp, animated: true, completion: nil)
    }
    
    func showSmallPopUp(_ inViewController: UIViewController,popUp: UIViewController) {
        
        popUp.modalPresentationStyle = UIModalPresentationStyle.popover
        
        let popover = popUp.popoverPresentationController
        popUp.preferredContentSize = CGSize(width: 300,height: 200)
        popover?.delegate = inViewController as? UIPopoverPresentationControllerDelegate
        popover?.sourceView = inViewController.view
        popover?.sourceRect = CGRect(x: inViewController.view.bounds.midX, y: inViewController.view.bounds.midY, width: 0, height: 0)
        popover?.permittedArrowDirections = UIPopoverArrowDirection(rawValue:0)
        
        inViewController.present(popUp, animated: true, completion: nil)
    }
    
    func showPopUpWithArrow(_ inViewController: UIViewController,popUp: UIViewController,arrowX: CGFloat,arrowY: CGFloat) {
        popUp.modalPresentationStyle = UIModalPresentationStyle.popover
        
        let popover = popUp.popoverPresentationController
        popUp.preferredContentSize = CGSize(width: inViewController.view.frame.width - 20,height: 400)
        popover?.delegate = inViewController as? UIPopoverPresentationControllerDelegate
        popover?.sourceView = inViewController.view
        popover?.permittedArrowDirections = .up
        popover?.sourceRect = CGRect(x: arrowX, y: arrowY, width: 0, height: 0)
        
        inViewController.present(popUp, animated: true, completion: nil)
    }
    
    func showAlertDialog(_ inViewController: UIViewController,title: String!,message: String,completion: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: title,message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: LanguageHelper.getStringLocalized("ok"), style: UIAlertActionStyle.default, handler: {_ in
            completion(true)
        }))
        alert.addAction(UIAlertAction(title: LanguageHelper.getStringLocalized("cancel"), style: UIAlertActionStyle.default, handler: {_ in
            completion(false)
        }))
        inViewController.present(alert, animated: true, completion: nil)
    }
    
    func showAlertDialogWithOnlyOk(_ inViewController: UIViewController,title: String!,message: String,completion: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: title,message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: LanguageHelper.getStringLocalized("ok"), style: UIAlertActionStyle.default, handler: {_ in
            completion(true)
        }))
        inViewController.present(alert, animated: true, completion: nil)
    }
    
    func showBottomAlert(_ msg: String,view: UIViewController) {
        let alert = UIAlertController(title: nil, message: msg, preferredStyle: .actionSheet)
        DispatchQueue.main.async {
            view.present(alert, animated: true){}
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    func takeImage(_ inViewController: UIViewController,title: [String])
    {
        
        let picker = UIImagePickerController()
        picker.delegate = inViewController as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        let alert = UIAlertController(title: title[0], message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: title[1], style: .default, handler: { (action) in
            picker.sourceType = UIImagePickerControllerSourceType.camera
            inViewController.present(picker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: title[2], style: .default, handler: { (action) in
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            inViewController.present(picker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: title[3], style: .cancel, handler: nil))
        inViewController.present(alert, animated: true, completion: nil)
    }
    
}
