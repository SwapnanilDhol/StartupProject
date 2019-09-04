//
//  SettingsTableViewTableViewController.swift
//  Startup Project
//
//  Created by Swapnanil Dhol on 9/3/19.
//  Copyright © 2019 Swapnanil Dhol. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        
        let alert = UIAlertController(title: "You're about to log out", message: "Are you sure you want to log out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (_) in
            //TODO: Perform Segue to exit user out of this
            //If Integrating with firebase please check the condition and then exit
            let vc = SignInViewController()
            self.present(vc, animated: true, completion: nil)
            
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
      
        return 5
    }
    




}
