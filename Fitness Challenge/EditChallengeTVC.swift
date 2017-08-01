//
//  EditChallengeTVC.swift
//  Fitness Challenge
//
//  Created by Travis Whitten on 7/27/17.
//  Copyright © 2017 Travis Whitten. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase
import FirebaseStorageUI

class EditChallengeTVC: UITableViewController, UITextFieldDelegate, UITextViewDelegate, UINavigationBarDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var TitleTF: UITextField!
    @IBOutlet weak var DurationTF: UITextField!
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var DescriptionTV: UITextView!
    @IBOutlet weak var RulesTV: UITextView!
    @IBOutlet weak var PrizesTV: UITextView!
    @IBOutlet weak var imgLbl: UILabel!
    
    var logoLocation = ""
    var challengeKey = ""
    
    @IBAction func uploadLogo(_ sender: Any) {
        handleSelectLogo()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(EditChallengeTVC.dismissKeyboard)))
        TitleTF.delegate = self
        
        DescriptionTV.delegate = self
        PrizesTV.delegate = self
        RulesTV.delegate = self
        DurationTF.delegate = self
        
        self.DurationTF.text = ""
        self.DescriptionTV.text = ""
        self.TitleTF.text = ""
        self.PrizesTV.text = ""
        self.RulesTV.text = ""
        
        fillChallenge()
        
        
        
        
        


           }
    
    @IBAction func applyTapped(_ sender: Any) {
        
        doneTapped()
        
    }
    
    
    func doneTapped() {
        //Current Users UID
        let currentUser = Auth.auth().currentUser!.uid
        //Checks to make sure user has entered all boxes
        if let title = TitleTF.text, let description = DescriptionTV.text,let rules = RulesTV.text,let prizes = PrizesTV.text, let challengeTime = DurationTF.text,let imgURL = imgLbl.text ,(title.characters.count > 0 && description.characters.count > 0 && challengeTime.characters.count > 0 && imgURL.characters.count > 0) {
            DataService.ds.REF_CHALLENGES.child(challengeKey).updateChildValues(["title": title ,"description": description,"rules": rules,"prizes": prizes ,"challengeTime": challengeTime, "imageURL": imgURL, "time": Firebase.ServerValue.timestamp(), "createdBy": currentUser, "logoLocation": self.logoLocation])
            //Loads the logo to storage
            //loadLogoToStorage()
            
            let alertController1 = UIAlertController(title: "Success", message:"Challenge has been Updated!", preferredStyle: .alert)
            let OKAction1 = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) in
                //self.dismiss(animated: false, completion: nil)
                self.performSegue(withIdentifier: "unwindEditToHome", sender: self)
                
            }
            alertController1.addAction(OKAction1)
            self.present(alertController1, animated: true, completion: nil)
            
            
        } else {
            //print("Must enter a title, description, and duration of challenge!")
            let alertController2 = UIAlertController(title: "ERROR", message:"All fields must be completed!", preferredStyle: .alert)
            let OKAction2 = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) in
                
                
            }
            alertController2.addAction(OKAction2)
            self.present(alertController2, animated: true, completion: nil)
            
        }
        //performSegue(withIdentifier: "backToChallenges", sender: self)
        self.reloadInputViews()
        
    }

    func fillChallenge() {
        
        DataService.ds.REF_CHALLENGES.child(challengeKey).observeSingleEvent(of: .value, with: { (snapshot) in
            
            self.TitleTF.text = snapshot.childSnapshot(forPath: "title").value! as? String
            self.DescriptionTV.text = snapshot.childSnapshot(forPath: "description").value! as! String
            self.RulesTV.text = snapshot.childSnapshot(forPath: "rules").value! as! String
            self.PrizesTV.text = snapshot.childSnapshot(forPath: "prizes").value! as! String
            self.DurationTF.text = snapshot.childSnapshot(forPath: "challengeTime").value! as? String
            self.imgLbl.text = snapshot.childSnapshot(forPath: "imageURL").value! as? String
            
            let stringURL = NSURL(string: self.imgLbl.text!)
            self.logoImg.sd_setImage(with: stringURL as URL?)
            
        })
    }

    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        TitleTF.resignFirstResponder()
        DurationTF.resignFirstResponder()
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        DescriptionTV.resignFirstResponder()
        
        return true
    }
    
    func completeChallenge(id: String, challengeData: Dictionary<String, String>) {
        DataService.ds.createChallenge(challengeID: id, challengeData: challengeData)
        //performSegue(withIdentifier: "backToChallenges", sender: self)
    }


    
}

extension EditChallengeTVC: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            logoImg.image = image
            loadLogoToStorage()
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
    
    func loadLogoToStorage() {
        let currentUser = Auth.auth().currentUser!.uid
        guard let img = logoImg.image else {
            print("WHITTEN: An Image must be selected")
            return
        }
        
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            
            let imgUID = NSUUID().uuidString
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            logoLocation = "\(currentUser)\(imgUID)"
            
            
            
            DataService.ds.STORAGE_LOGOS.child(logoLocation).putData(imgData, metadata: metadata) { (metadata, error) in
                
                if error != nil {
                    print("WHITTEN: Unable to upload image to FireBase Storage")
                } else {
                    
                    print("WHITTEN: Succesfully uploaded image to Firebase Storage")
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    self.imgLbl.text = ("\(downloadURL!)")
                    
                    
                }
                
                
                
            }
            
            
            
        }
        
        
        
        
    }
    

    
    
}
