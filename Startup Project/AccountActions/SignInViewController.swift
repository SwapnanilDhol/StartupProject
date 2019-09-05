//
//  SignInViewController.swift
//  Startup Project
//
//  Created by Swapnanil Dhol on 9/3/19.
//  Copyright © 2019 Swapnanil Dhol. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD


class SignInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let generator = UINotificationFeedbackGenerator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailLabel.delegate = self
        self.passwordTextField.delegate = self
        
        emailLabel.setLeftPaddingPoints(10)
        passwordTextField.setLeftPaddingPoints(10)

        SVProgressHUD.setDefaultStyle(.dark)
        
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func signInButton(_ sender: Any) {
        
        
        if emailLabel.text != nil && passwordTextField.text != nil
        {
            Auth.auth().signIn(withEmail: emailLabel.text!, password: passwordTextField.text!) { (user, error) in
                
                if user != nil
                {
                    
                    self.generator.notificationOccurred(.success)
                    SVProgressHUD.showSuccess(withStatus: "Logged in!")
                
                    
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    print(UserDefaults.standard.string(forKey: "isLoggedIn")!)
                    self.performSegue(withIdentifier: "succesfullySignedIn", sender: self)
                    SVProgressHUD.dismiss(withDelay: 2)
                    
                }
                else
                {
                    
                    self.generator.notificationOccurred(.warning)
                    SVProgressHUD.showError(withStatus: error?.localizedDescription)
                    SVProgressHUD.dismiss(withDelay: 3)
                    
                }
            }
        }
        
    }
        
        
    
    
    @IBAction func dontHaveAPassButton(_ sender: Any) {
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        emailLabel.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction func forgotPasswordButton(_ sender: Any) {
        
        
        if emailLabel.text == "" {
            self.generator.notificationOccurred(.error)
            let alert = UIAlertController(title: "Reset Password", message: "To reset your password type in your registered email ID and then tap the Forgot Password button", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil) }
            
        else
        {
            Auth.auth().sendPasswordReset(withEmail: emailLabel.text!) { (error) in
                
                if error == nil
                {
                    SVProgressHUD.showSuccess(withStatus: "Password Reset Instructions sent to your email.")
                    SVProgressHUD.dismiss(withDelay: 1.5)
                }
                else {
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
        
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
