//
//  ViewController.swift
//  KeyboardEventHandler
//
//  Created by Smirnov Yuriy on 05/22/2016.
//  Copyright (c) 2016 Smirnov Yuriy. All rights reserved.
//

import UIKit

import KeyboardEventHandler

class ViewController: UIViewController {
    
    private var keyboardHandler : KeyboardHandler?
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //configurate KeyboardHandler, convenience init
        keyboardHandler = KeyboardHandler(
            constraint: bottomConstraint,
            forView: button
        )
        
    }
    
}

//MARK: - Action

extension ViewController {
    
    @IBAction func buttonAction(sender: AnyObject) {
        
        view.endEditing(true)   //hide keyboard
        
    }
    
}

//MARK: - UITextFieldDelegate

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
}