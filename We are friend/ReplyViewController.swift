//
//  ReplyViewController.swift
//  We are friend
//
//  Created by おのしょうき on 2022/11/20.
//

import UIKit

class ReplyViewController: UIViewController {
    @IBOutlet var textField: UITextField!
    
    var textFieldString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func tableViewTap(_ sender: Any){
        self.view.endEditing(true)
        resignFirstResponder()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(self.keyboardWillShow(_:)),
                                 name: UIResponder.keyboardWillShowNotification,
                                 object: nil)
        notification.addObserver(self, selector: #selector(self.keyboardWillHide(_:)),
                                 name: UIResponder.keyboardWillHideNotification,
                                 object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        let rect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        guard let keyboardHeight = rect?.size.height else { return }
        let mainBoundsSize = UIScreen.main.bounds.size
        let textFieldHeight = textField.frame.height
        
        let textFieldPositionY = textField.frame.origin.y + textFieldHeight + 10.0
        let keyboardPositionY = keyboardHeight
        
        if keyboardPositionY <= textFieldPositionY {
            let duration: TimeInterval? =
            notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
            UIView.animate(withDuration: duration!) {
                self.view.transform = CGAffineTransform(translationX: 0, y: -keyboardPositionY)
            }
        }
    }
    
    // キーボード非表示通知の際の処理
    @objc func keyboardWillHide(_ notification: Notification) {
        let duration: TimeInterval? = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Double
        UIView.animate(withDuration: duration ?? 0, delay: 0, options: .curveEaseOut) {
            self.view.transform = CGAffineTransform.identity
        }
    }
    @IBAction func pushBotton(_ sender: UIButton) {
        
        textFieldString = textField.text!
        
        textField.text = ""
        
    }

    
    
}
