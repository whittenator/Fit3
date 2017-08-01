//
//  CreateChallengeTVC.swift
//  Fitness Challenge
//
//  Created by Travis Whitten on 7/25/17.
//  Copyright © 2017 Travis Whitten. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class CreateChallengeTVC: UITableViewController, UITextFieldDelegate, UITextViewDelegate, UINavigationBarDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var durationTF: UITextField!
    @IBOutlet weak var descriptionTV: UITextView!
    @IBOutlet weak var rulesTV: UITextView!
    @IBOutlet weak var prizesTV: UITextView!
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var imageLbl: UILabel!
 
    
    
    var logoLocation = ""
    var pickerData: [Int] = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CreateChallengeTVC.dismissKeyboard)))
        titleTF.delegate = self
        
        descriptionTV.delegate = self
        prizesTV.delegate = self
        rulesTV.delegate = self
        durationTF.delegate = self
        
        self.durationTF.text = ""
        self.descriptionTV.text = ""
        self.titleTF.text = ""
        self.prizesTV.text = ""
        self.rulesTV.text = ""
        
        
        
       

        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
        self.navigationItem.rightBarButtonItem!.tintColor = UIColor.init(red: 0.40, green: 0.85, blue: 1.0, alpha: 1.0)
        self.navigationItem.rightBarButtonItem!.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Avenir Next", size: 20)!], for: .normal)
    }
    
    @IBAction func uploadLogo(_ sender: Any) {
        handleSelectLogo()
    }

    
    func doneTapped() {
        //Current Users UID
        let currentUser = Auth.auth().currentUser!.uid
        //Checks to make sure user has entered all boxes
        if let title = titleTF.text, let description = descriptionTV.text,let rules = rulesTV.text,let prizes = prizesTV.text, let challengeTime = durationTF.text,let imgURL = imageLbl.text ,(title.characters.count > 0 && description.characters.count > 0 && challengeTime.characters.count > 0 && imgURL.characters.count > 0) {
            DataService.ds.REF_CHALLENGES.childByAutoId().setValue(["title": title ,"description": description,"rules": rules,"prizes": prizes ,"challengeTime": challengeTime, "imageURL": imgURL, "time": Firebase.ServerValue.timestamp(), "createdBy": currentUser, "logoLocation": self.logoLocation])
            //Loads the logo to storage
            //loadLogoToStorage()
            
            let alertController1 = UIAlertController(title: "Success", message:"Challenge has been created!", preferredStyle: .alert)
            let OKAction1 = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) in
                self.dismiss(animated: true, completion: nil)
                
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
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTF.resignFirstResponder()
        durationTF.resignFirstResponder()
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        descriptionTV.resignFirstResponder()
        
        return true
    }
    
    func completeChallenge(id: String, challengeData: Dictionary<String, String>) {
        DataService.ds.createChallenge(challengeID: id, challengeData: challengeData)
        //performSegue(withIdentifier: "backToChallenges", sender: self)
    }
    
   
    
    
}

extension CreateChallengeTVC: UIImagePickerControllerDelegate {
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
                    self.imageLbl.text = ("\(downloadURL!)")
                    
                    
                }
                
                
                
            }
            
            
            
        }
        
        
        
        
    }

    
}


