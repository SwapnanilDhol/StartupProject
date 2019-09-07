//
//  ViewController.swift
//  Startup Project
//
//  Created by Swapnanil Dhol on 9/2/19.
//  Copyright © 2019 Swapnanil Dhol. All rights reserved.
//

import UIKit
import MKMagneticProgress
import JJFloatingActionButton
import Firebase
import FirebaseStorage

class DocumentsUploadViewController: UIViewController{
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var uploadStatusLabel: UILabel!
    @IBOutlet weak var magProgress:MKMagneticProgress!
    let actionButton = JJFloatingActionButton()
    let percent = "%"
    
    
    var collectionItems = ["Medical Bills", "Treatment Plan", "Prescription", "Documents by Doctor", "Pictures"]
    var progress: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.navigationBar.tintColor = .purple
        self.navigationItem.title = "Fast Settlement Tracker"
        self.navigationController?.navigationBar.backgroundColor = .purple
        
        
        magProgress.progressShapeColor = UIColor.red
        magProgress.backgroundShapeColor = UIColor.lightGray
        magProgress.percentColor = UIColor.black
        
        magProgress.orientation = .top
        magProgress.clockwise = true
        magProgress.font = UIFont(name: "Arial", size: 40)!
        magProgress.lineCap = .round
        magProgress.percentLabelFormat = "%d%%"
        
        
        collectionView.dataSource = self
        collectionView.delegate = self
        uploadStatusLabel.text = " Please Provide Injury Details "
        uploadStatusLabel.layer.masksToBounds = true
        uploadStatusLabel.layer.cornerRadius = 10
        
        configFloatingActionButton()
        updateProgessCircle(progressz: progress)
        
        
    }
    
    
    
    func configFloatingActionButton()
    {
        actionButton.buttonImage = UIImage(imageLiteralResourceName: "Tap2SpeakIcon")
        
        actionButton.addItem(title: "item 1", image: UIImage(named: "First")?.withRenderingMode(.alwaysTemplate)) { item in
            // self.performSegue(withIdentifier: "chatBotSegue", sender: self)
            
            let modelVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatBot") as! ChatViewController
            let navBarOnModal: UINavigationController = UINavigationController(rootViewController: modelVC)
            self.present(navBarOnModal, animated: true, completion: nil)
        }
        
        
        view.addSubview(actionButton)
        actionButton.buttonColor = UIColor(red:0.43, green:0.23, blue:0.76, alpha:1.0)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        
        
    }
    
    func updateProgessCircle(progressz: Int)
   {
    
    magProgress.setProgress(progress: CGFloat(progressz)/100, animated: true)
    magProgress.percentLabelFormat = "\(String(progressz))\(percent)"
    if progressz == 60
    {
       magProgress.progressShapeColor = UIColor.orange
    
    }
    else if progressz == 80 {
        
        magProgress.progressShapeColor = UIColor.green
    }
    
    else if progressz == 100 {
        
        magProgress.progressShapeColor = UIColor(red:0.10, green:0.43, blue:0.30, alpha:1.0)
    }
    
    
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
            let alert = UIAlertController(title: "Upload Documents", message: "Please upload documents", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Document", style: .default, handler: { (_) in
                
                //USER UPLOADED DOCUMENT
                
                if self.collectionItems[indexPath.row].contains("✅") {
                    
                    //Document has already been uploaded
                    
                    self.dismiss(animated: true, completion:nil)
                    print("Already Uploaded")
                    
                }
                else {
                    
                    self.progress = self.progress + 20
                    self.updateProgessCircle(progressz: self.progress)
                    self.collectionItems[indexPath.row] = "✅" + self.collectionItems[indexPath.row]

                    self.collectionView.reloadData()
         
                }
                
                
            }))
            alert.addAction(UIAlertAction(title: "Image", style: .default, handler: { (_) in
                if self.collectionItems[indexPath.row].contains("✅") {
                    
                    //Document has already been uploaded
                    
                    self.dismiss(animated: true, completion:nil)
                    print("Already Uploaded")
                    
                }
                else {
                    self.progress = self.progress + 20
                    self.updateProgessCircle(progressz: self.progress)
                    self.collectionItems[indexPath.row] = "✅" + self.collectionItems[indexPath.row]
            
                        self.collectionView.reloadData()
                
                }
            }))
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            
            present(alert, animated: true, completion: nil)
            break
        case 1:
            let alert = UIAlertController(title: "Upload Documents", message: "Please upload documents", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Document", style: .default, handler: { (_) in
                if self.collectionItems[indexPath.row].contains("✅") {
                    
                    //Document has already been uploaded
                    
                    self.dismiss(animated: true, completion:nil)
                    print("Already Uploaded")
                    
                }
                else {
                    self.progress = self.progress + 20
                    self.updateProgessCircle(progressz: self.progress)
                    self.collectionItems[indexPath.row] = "✅" + self.collectionItems[indexPath.row]
                 
                        self.collectionView.reloadData()
                    
                }
            }))
            alert.addAction(UIAlertAction(title: "Image", style: .default, handler: { (_) in
                if self.collectionItems[indexPath.row].contains("✅") {
                    
                    //Document has already been uploaded
                    
                    self.dismiss(animated: true, completion:nil)
                    print("Already Uploaded")
                    
                }
                else {
                    self.progress = self.progress + 20
                    self.updateProgessCircle(progressz: self.progress)
                    self.collectionItems[indexPath.row] = "✅" + self.collectionItems[indexPath.row]
              
                        self.collectionView.reloadData()
                   
                }
            }))
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            break
            
        case 2:
            let alert = UIAlertController(title: "Upload Documents", message: "Please upload documents", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Document", style: .default, handler: { (_) in
                if self.collectionItems[indexPath.row].contains("✅") {
                    
                    //Document has already been uploaded
                    
                    self.dismiss(animated: true, completion:nil)
                    print("Already Uploaded")
                    
                }
                else {
                    self.progress = self.progress + 20
                    self.updateProgessCircle(progressz: self.progress)
                    self.collectionItems[indexPath.row] = "✅" + self.collectionItems[indexPath.row]
          
                        self.collectionView.reloadData()
                    
                }
            }))
            alert.addAction(UIAlertAction(title: "Image", style: .default, handler: { (_) in
                if self.collectionItems[indexPath.row].contains("✅") {
                    
                    //Document has already been uploaded
                    
                    self.dismiss(animated: true, completion:nil)
                    print("Already Uploaded")
                    
                }
                else {
                    self.progress = self.progress + 20
                    self.updateProgessCircle(progressz: self.progress)
                    self.collectionItems[indexPath.row] = "✅" + self.collectionItems[indexPath.row]
                   
                        self.collectionView.reloadData()
                    
                }
            }))
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            break
        case 3:
            let alert = UIAlertController(title: "Upload Documents", message: "Please upload documents", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Document", style: .default, handler: { (_) in
                if self.collectionItems[indexPath.row].contains("✅") {
                    
                    //Document has already been uploaded
                    
                    self.dismiss(animated: true, completion:nil)
                    print("Already Uploaded")
                    
                }
                else {
                    self.progress = self.progress + 20
                    self.updateProgessCircle(progressz: self.progress)
                    self.collectionItems[indexPath.row] = "✅" + self.collectionItems[indexPath.row]
               
                        self.collectionView.reloadData()
                    
                }
            }))
            alert.addAction(UIAlertAction(title: "Image", style: .default, handler: { (_) in
                if self.collectionItems[indexPath.row].contains("✅") {
                    
                    //Document has already been uploaded
                    
                    self.dismiss(animated: true, completion:nil)
                    print("Already Uploaded")
                    
                }
                else {
                    self.progress = self.progress + 20
                    self.updateProgessCircle(progressz: self.progress)
                    self.collectionItems[indexPath.row] = "✅" + self.collectionItems[indexPath.row]
                    
                        self.collectionView.reloadData()
                    
                }
            }))
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            break
        case 4:
            let alert = UIAlertController(title: "Upload Documents", message: "Please upload documents", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Document", style: .default, handler: { (_) in
                if self.collectionItems[indexPath.row].contains("✅") {
                    
                    //Document has already been uploaded
                    
                    self.dismiss(animated: true, completion:nil)
                    print("Already Uploaded")
                    
                }
                else {
                    self.progress = self.progress + 20
                    self.updateProgessCircle(progressz: self.progress)
                    self.collectionItems[indexPath.row] = "✅" + self.collectionItems[indexPath.row]
                  
                        self.collectionView.reloadData()
                
                }
            }))
            alert.addAction(UIAlertAction(title: "Image", style: .default, handler: { (_) in
                if self.collectionItems[indexPath.row].contains("✅") {
                    
                    //Document has already been uploaded
                    
                    self.dismiss(animated: true, completion:nil)
                    print("Already Uploaded")
                    
                }
                else {
                    self.progress = self.progress + 20
                    self.updateProgessCircle(progressz: self.progress)
                    self.collectionItems[indexPath.row] = "✅" + self.collectionItems[indexPath.row]
                        self.collectionView.reloadData()
                    
                }
            }))
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
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

