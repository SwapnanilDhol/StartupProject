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
import FirebaseStorage
import SafariServices

class SettingsTableViewController: UITableViewController, SFSafariViewControllerDelegate {
    
    var userProfilePicUrl : String = UserDefaults.standard.value(forKey: "profilePicUrl") as? String ?? ""

    let generator = UINotificationFeedbackGenerator()
    let storage = Storage.storage()
    var imagePicker = UIImagePickerController()
    var uid = Auth.auth().currentUser?.uid

    

    @IBOutlet weak var userPhoto: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userPhoto.layer.cornerRadius = userPhoto.frame.width / 2
        userPhoto.image = UIImage(imageLiteralResourceName: "Avatar")
        print(userProfilePicUrl)
        if userProfilePicUrl != ""
        {
            DispatchQueue.main.async {
                self.userPhoto.imageFromServerURL(urlString: self.userProfilePicUrl)
            }
            
            print("userImageDownloaded")
        }
        
        
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath == [0,0]
        {
            setupImagePicker()
        }
        
        else if indexPath == [1,0]
        {
            let urlString = "https://myfastclaim.com/#team"
            
            if let url = URL(string: urlString) {
                let vc = SFSafariViewController(url: url)
                vc.delegate = self
                
                present(vc, animated: true)
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
      
        return 5
    }
    




}

extension UIImageView {
    public func imageFromServerURL(urlString: String) {
        self.image = nil
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
            
        }).resume()
    }}
extension SettingsTableViewController:  UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    
    func setupImagePicker(){
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    func uploadImage()
    {
        
        SVProgressHUD.show(withStatus: "Uploading Image")
        let imageName = uid ?? ""
        let storageRef = Storage.storage().reference().child("profilepics").child("\(imageName).png")
        
        if let uploadData = self.userPhoto.image?.pngData()
        {
         storageRef.putData(uploadData, metadata: nil) { (metaData, error) in
            
         
            
            
                
                
                
                if error != nil {
                    print(error?.localizedDescription ?? "")
                    return
                }
                else{
                    storageRef.downloadURL(completion: { (url, error) in
                        if error != nil {
                            SVProgressHUD.dismiss()
                           SVProgressHUD.showError(withStatus: error?.localizedDescription)
                            
                            
                        }
                        else
                        {
                            
                            UserDefaults.standard.set(url?.absoluteString, forKey: "profilePicUrl")
                        }
                    })
                  
                    SVProgressHUD.dismiss()
                    print("Upload Successful")
                }
                
            }
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            
            userPhoto.contentMode = .scaleAspectFit
            userPhoto.image = editedImage
            
            
            
            
        }
        
        dismiss(animated: true) {
            self.uploadImage()
           
        }
    }
    
    
}
