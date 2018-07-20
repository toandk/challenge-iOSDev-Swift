//
//  BaseViewController.swift
//  NoteSwift
//
//  Created by ToanDK on 7/20/18.
//  Copyright © 2018 ToanDK. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, UIGestureRecognizerDelegate {
    
    func addRightMenuButton(title: String, target: AnyObject, selector: Selector) {
        let button = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)
        self.navigationItem.rightBarButtonItem = button
    }
    
    func showAlert(title: String, message: String) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            print("OK action")
        }
        
        alertView.addAction(okAction)
        self.present(alertView, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintAdjustmentMode = .normal
        self.navigationController?.navigationBar.tintAdjustmentMode = .automatic
    }
    
    func addKeyboardTapGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(_:)))
        self.view.addGestureRecognizer(gesture)
        gesture.cancelsTouchesInView = false
        gesture.delegate = self
    }
    
    func removeKeyboardTapGesture() {
        if let gestures = self.view.gestureRecognizers {
            for gesture in gestures {
                gesture.delegate = nil
                self.view.removeGestureRecognizer(gesture)
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let _ = touch.view as? UIControl {
            return false
        }
        return true
    }
    
    @objc func hideKeyboard(_ gesture: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}
