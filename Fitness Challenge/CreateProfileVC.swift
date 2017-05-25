//
//  CreateProfileVC.swift
//  Fitness Challenge
//
//  Created by Travis Whitten on 1/3/17.
//  Copyright © 2017 Travis Whitten. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorageUI

class CreateProfileVC: UIViewController, UINavigationBarDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTF: UITextField!
    
    @IBOutlet weak var bioTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    
    @IBOutlet weak var ageTF: UITextField!
    @IBOutlet weak var profileImg: UIImageView!
    
    
    @IBOutlet weak var weightTF: UITextField!
    
    @IBOutlet weak var genderSegment: UISegmentedControl!
    
    var downloadURL = ""
    
    
    @IBAction func changeProfileImg(_ sender: Any) {
        handleSelectLogo()
    }
    
    
    
    
    @IBAction func applyBtnPressed(_ sender: Any) {
    
        
        let username = usernameTF.text
        let bio = bioTF.text
        let name = nameTF.text
        let age = ageTF.text
        let gender = genderSegment.titleForSegment(at: genderSegment.selectedSegmentIndex)
        let weight = weightTF.text
        
        if ((username?.characters.count)! > 0 && (gender?.characters.count)! > 0 && (downloadURL.characters.count) > 0) {


    DataService.ds.REF_USERS.child(Auth.auth().currentUser!.uid).child("profile").setValue(["userName": username ,"bio": bio, "name": name, "age": age, "gender":gender,"weight": weight, "profileImg": downloadURL])
        
            let alertController2 = UIAlertController(title: "Success", message:"Profile has been updated!", preferredStyle: .alert)
            let OKAction2 = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) in
                print("You've pressed OK button");
                
            }
            alertController2.addAction(OKAction2)
            self.present(alertController2, animated: true, completion: nil)
            
        
        } else {
            mustEnterUsername()
        }
        //performSegue(withIdentifier: "backToProfile", sender: nil)
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
    

    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        genderSegment.tintColor = UIColor.white

            self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CreateProfileVC.dismissKeyboard)))
        ageTF.delegate = self
        weightTF.delegate = self
        bioTF.delegate = self
        nameTF.delegate = self
        usernameTF.delegate = self
        
        fillProfileTF()
        
        //Setting Profile Image to be rounded
        self.view.layoutIfNeeded()
        
        profileImg.layer.cornerRadius = profileImg.frame.size.height/2
        profileImg.contentMode = .scaleAspectFill
        profileImg.clipsToBounds = true
        profileImg.layer.borderWidth = 3
        profileImg.layer.borderColor = UIColor.white.cgColor
 
        
        
        
        
    }
    
    func fillProfileTF() {
        DataService.ds.REF_USERS.child(Auth.auth().currentUser!.uid).child("profile").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.usernameTF.text = dictionary["userName"] as? String
                self.bioTF.text = dictionary["bio"] as? String
                self.weightTF.text = dictionary["weight"] as? String
                self.nameTF.text = dictionary["name"] as? String
                self.ageTF.text = dictionary["age"] as? String
                //self.profileImg = dictionary["profileImg"] as! UIImageView
                let stringURL = NSURL(string: dictionary["profileImg"] as! String)
                self.profileImg.sd_setImage(with: stringURL as URL?)
                if (dictionary["gender"] as? String == "Male") {
                    self.genderSegment.selectedSegmentIndex = 0
                } else {
                    self.genderSegment.selectedSegmentIndex = 1
                }
                
            }

            
        }, withCancel: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameTF.resignFirstResponder()
        bioTF.resignFirstResponder()
        nameTF.resignFirstResponder()
        
        weightTF.resignFirstResponder()
        return true
    }
    
    func roundingUIView( aView: UIView!, cornerRadiusParam: CGFloat!) {
        
        aView.clipsToBounds = true
        aView.layer.cornerRadius = cornerRadiusParam
        
        
    }
    
    
    


}


extension CreateProfileVC: UIImagePickerControllerDelegate {
    
    
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

