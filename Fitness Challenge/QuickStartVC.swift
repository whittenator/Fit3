//
//  QuickStartVC.swift
//  Fitness Challenge
//
//  Created by Travis Whitten on 6/6/17.
//  Copyright © 2017 Travis Whitten. All rights reserved.
//

import UIKit
import Firebase

class QuickStartVC: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var genderSeg: UISegmentedControl!
    @IBOutlet weak var birthdatePicker: UIDatePicker!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    
    
    
    var downloadURL = ""
    var bio = ""
    var name = ""
    var age = ""
    var weight = ""
    var username = ""
    var gender = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
   
   
   
    
    

    
    @IBAction func uploadProfileImg(_ sender: Any) {
        handleSelectLogo()
    }

    @IBAction func doneBtnTapped(_ sender: Any) {
        
        
        let bio = ""
        let name = ""
        let age = ""
        let weight = ""
       username = usernameTF.text!
        
        self.gender = genderSeg.titleForSegment(at: genderSeg.selectedSegmentIndex)!
        
        if ((self.username.characters.count) > 0 && (downloadURL.characters.count) > 0) {
            
            
            DataService.ds.REF_REPORTS.child("TEST").setValue(["userName": username ,"bio": bio, "name": name, "age": age, "gender":gender,"weight": weight, "profileImg": downloadURL])
            
            let alertController2 = UIAlertController(title: "Success", message:"Profile has been updated!", preferredStyle: .alert)
            let OKAction2 = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) in
                print("You've pressed OK button")
                
            }
            alertController2.addAction(OKAction2)
            self.present(alertController2, animated: true, completion: nil)
            
            
        } else {
            mustEnterUsername()
        }
        //performSegue(withIdentifier: "goToProfile", sender: nil)
        print("User Info Saved")
        
    }
    
    func mustEnterUsername() {
        let alertController2 = UIAlertController(title: "ERROR", message:"Must enter a username, gender and upload a profile image!", preferredStyle: .alert)
        let OKAction2 = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) in
            print("You've pressed OK button");
            
        }
        alertController2.addAction(OKAction2)
        self.present(alertController2, animated: true, completion: nil)
        
        
    }
    
    func saveData() {
        
        
        
        
    }
   

}

extension QuickStartVC: UIImagePickerControllerDelegate {
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            profileImg.image = image
            loadProfileImgToStorage()
            print("WHITTEN: Valid image selected")
        } else {
            print("WHITTEN: A valid image isn't selected")
        }
        
        
        
        dismiss(animated: true, completion: nil)
        
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func handleSelectLogo() {
        
        let picker = UIImagePickerController()
        picker.delegate = self 
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
        
        
        
        
        
    }
    
    func loadProfileImgToStorage() {
        let currentUser = Auth.auth().currentUser!.uid
        guard let img = profileImg.image else {
            print("WHITTEN: An Image must be selected")
            return
        }
        
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            
            let imgUID = NSUUID().uuidString
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            DataService.ds.STORAGE_PROFILE_IMAGES.child("\(currentUser).\(imgUID)").putData(imgData, metadata: metadata) { (metadata, error) in
                
                if error != nil {
                    print("WHITTEN: Unable to upload image to FireBase Storage")
                } else {
                    
                    print("WHITTEN: Succesfully uploaded image to Firebase Storage")
                    self.downloadURL = (metadata?.downloadURL()?.absoluteString)!
                    //self.imageLbl.text = ("\(downloadURL!)")
                    
                    
                }
                
                
                
            }
            
            
            
        }
        
        
        
        
    }
}
