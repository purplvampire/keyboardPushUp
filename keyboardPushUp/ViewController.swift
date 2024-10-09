//
//  ViewController.swift
//  keyboardPushUp
//
//  Created by 陳信彰 on 2024/10/10.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwdTextField: UITextField!
    
    var activeTextField: UITextField!   // 宣告編輯框
    
    let center: NotificationCenter = .default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 指定呼叫TextField內建Function的代理人
        nameTextField.delegate = self
        passwdTextField.delegate = self
        
        // 監聽鍵盤
        center.addObserver(self, selector: #selector(keyboardWillShow),
                           name: UIResponder.keyboardWillShowNotification,
                           object: nil)
        
        center.addObserver(self, selector: #selector(keyboardWillHide),
                           name: UIResponder.keyboardWillHideNotification,
                           object: nil)
    }
    
    // 編輯時，儲存實體
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    @objc
    func keyboardWillShow(notification: Notification) {
        // 將view上移
        let info: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardY = self.view.frame.height - keyboardFrame.height
        let editingTextFieldY = activeTextField.convert(activeTextField.bounds, to: self.view).maxY
        let targetY = editingTextFieldY - keyboardY // 判斷是否有擋住
        
        let offsetY: CGFloat = 20.0
        
        if self.view.frame.minY >= 0 {
            guard targetY > 0 else { return }
            UIView.animate(withDuration: 0.25) {
                self.view.frame = CGRect(x: 0,
                                         y: -targetY - offsetY, // 以擋住的高度+20作為上移的距離
                                         width: self.view.bounds.width,
                                         height: self.view.bounds.height)
            }
        }
        
        
    }
    
    @objc
    func keyboardWillHide(notification: Notification) {
        // 回復view的高度
        UIView.animate(withDuration: 0.25) {
            self.view.frame = CGRect(x: 0,
                                     y: 0,
                                     width: self.view.bounds.width,
                                     height: self.view.bounds.height)
        }
    }
}

extension ViewController: UITextFieldDelegate {
    // 收鍵盤
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
