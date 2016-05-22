//
//  KeyboardHandler.swift
//  RealTracking
//
//  Created by nov on 04.01.16.
//  Copyright © 2016 TheMindStudios. All rights reserved.
//

import UIKit

public class KeyboardHandler: NSObject {
    
    private weak var viewConstraint: NSLayoutConstraint?
    private var originalConstant : CGFloat = 0.0
    private weak var animatedView : UIView?
    private var keyboardIsPresent: Bool = false
    private var offsetForView: CGFloat = 0.0
    
    public var completion : ((Bool) -> Void)?
    
    public convenience init(constraint: NSLayoutConstraint, forView:UIView, withOffset offset:CGFloat = 0)  {
        self.init()
        
        viewConstraint = constraint
        originalConstant = constraint.constant
        animatedView = forView
        offsetForView = offset
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(KeyboardHandler.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(KeyboardHandler.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(KeyboardHandler.keyboardDidShow(_:)), name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(KeyboardHandler.keyboardDidHide(_:)), name: UIKeyboardDidHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(KeyboardHandler.keyboardWillChangeFrame(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    private func handleConstraintWithNotification(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            if let keyboardHeight = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size.height {
                
                let newConstant = originalConstant + keyboardHeight + offsetForView
                
                if viewConstraint?.constant != newConstant {
                    viewConstraint?.constant = newConstant
                    UIView.animateWithDuration(userInfo[UIKeyboardAnimationDurationUserInfoKey]!.doubleValue) { [weak self] in
                        self?.animatedView?.layoutIfNeeded()
                    }
                }
            }
        }
    }
    
    public func keyboardWillShow(sender: NSNotification) {
        if keyboardIsPresent == false {
            
            handleConstraintWithNotification(sender)
            
        }
    }
    
    public func keyboardDidShow(sender: NSNotification) {
        keyboardIsPresent = true
        
        if let completion = completion {
            completion(keyboardIsPresent)
        }
    }
    
    public func keyboardWillHide(sender: NSNotification) {
        if let userInfo = sender.userInfo {
            if viewConstraint?.constant != originalConstant {
                viewConstraint?.constant = originalConstant
                UIView.animateWithDuration(userInfo[UIKeyboardAnimationDurationUserInfoKey]!.doubleValue) { [weak self] in
                    self?.animatedView?.layoutIfNeeded()
                }
            }
        }
    }
    
    public func keyboardDidHide(sender: NSNotification) {
        keyboardIsPresent = false
    }
    
    public func keyboardWillChangeFrame(sender: NSNotification) {
        
        if keyboardIsPresent == true {
            
            handleConstraintWithNotification(sender)
            
        }
    }
    
}