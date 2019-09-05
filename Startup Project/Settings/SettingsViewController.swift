//
//  SettingsViewController.swift
//  Startup Project
//
//  Created by Swapnanil Dhol on 9/3/19.
//  Copyright © 2019 Swapnanil Dhol. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController{

   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }
    
}

extension SettingsViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Hello World"
        cell.textLabel?.font = cell.textLabel?.font.withSize(40)
        return cell
        
    }
}
