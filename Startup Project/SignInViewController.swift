//
//  SignInViewController.swift
//  Startup Project
//
//  Created by Swapnanil Dhol on 9/3/19.
//  Copyright © 2019 Swapnanil Dhol. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var claimNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
self.claimNumberTextField.delegate = self
self.passwordTextField.delegate = self 
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    @IBAction func signInButton(_ sender: Any) {
        
    }
    
    @IBAction func dontHaveAPassButton(_ sender: Any) {
        
    }
    
    @IBAction func forgotPasswordButton(_ sender: Any) {
        
    }
}
