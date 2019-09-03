//
//  ViewController.swift
//  Startup Project
//
//  Created by Swapnanil Dhol on 9/2/19.
//  Copyright © 2019 Swapnanil Dhol. All rights reserved.
//

import UIKit


class DocumentsUploadViewController: UIViewController{
    
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var progressBarView: UIView!
    
    @IBOutlet weak var uploadStatusLabel: UILabel!
    
    let collectionItems = ["✅ Medical Bills", "✅ Treatment Plan", "Prescription", "Documents by Doctor", "Pictures"]

    

   // let progressRing = UICircularProgressRing()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       self.navigationController?.navigationBar.tintColor = .purple
        self.navigationItem.title = "Fast Settlement Tracker"
        self.navigationController?.navigationBar.backgroundColor = .purple
        
        collectionView.dataSource = self
        collectionView.delegate = self
        uploadStatusLabel.text = " Please Provide Injury Details "
        uploadStatusLabel.layer.masksToBounds = true
        uploadStatusLabel.layer.cornerRadius = 10
        

    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        
    }


}

extension DocumentsUploadViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionItems.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FastSettlementTrackerCell
        cell.label.text = collectionItems[indexPath.row]
        
        cell.layer.cornerRadius = 12
        cell.layer.masksToBounds = false
        cell.layer.shadowRadius = 8
        return cell
        
        
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            print("Medical Bills")
        //TODO: MEDICAL BILLS
        case 1:
            print("Treatment Plan")
        //TODO: Treatment Plan
            break
        case 2:
            print("Prescription")
        //TODO: Prescription
            break
        case 3:
            print("Doctor Documents")
        //TODO: Doctor Documents
            break
        case 4:
            print("Pictures")
        //TODO: Pictures
            break
        default: break
            
        }
    }
}




class FastSettlementTrackerCell : UICollectionViewCell{
    
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

