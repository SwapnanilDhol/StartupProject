//
//  SettingsTableViewTableViewController.swift
//  Startup Project
//
//  Created by Swapnanil Dhol on 9/3/19.
//  Copyright © 2019 Swapnanil Dhol. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class SettingsTableViewController: UITableViewController {

    let generator = UINotificationFeedbackGenerator()
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        
        let alert = UIAlertController(title: "You're about to log out", message: "Are you sure you want to log out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (_) in
            do{
                
                try Auth.auth().signOut()
                SVProgressHUD.showSuccess(withStatus: "Successfully Signed Out")
                
                self.generator.notificationOccurred(.success)
                print("Successfully Signed Out")
                UserDefaults.standard.set(false, forKey: "isLoggedIn")
                self.dismiss(animated: true, completion: {
                    self.performSegue(withIdentifier: "backHomeSegue", sender: self)
                })
                SVProgressHUD.dismiss(withDelay: 2)
                
            }
            catch
            {
                
                self.generator.notificationOccurred(.error)
                SVProgressHUD.showError(withStatus: error.localizedDescription)
                SVProgressHUD.dismiss(withDelay: 2)
                print(error)
            }
            
            
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
      
        return 5
    }
    




}
