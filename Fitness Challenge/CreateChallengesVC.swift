//
//  CreateChallengesVC.swift
//  Fitness Challenge
//
//  Created by Travis Whitten on 12/28/16.
//  Copyright © 2016 Travis Whitten. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class CreateChallengesVC: UIViewController,UITableViewDataSource,UITextFieldDelegate, UITextViewDelegate, UINavigationBarDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var homeButton2: UIBarButtonItem!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var durationTF: UITextField!
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var imageLbl: UILabel!
    
    
    //Logo Image Location
    var logoLocation = ""
    
    
    
    @IBAction func uploadLogo(_ sender: Any) {
        handleSelectLogo()
    }
    
    
    
    @IBAction func submitChallenge(_ sender: Any) {
        //Current Users UID
        let currentUser = Auth.auth().currentUser!.uid
        //Checks to make sure user has entered all boxes
        if let title = titleTF.text, let description = descriptionTextView.text, let challengeTime = durationTF.text,let imgURL = imageLbl.text ,(title.characters.count > 0 && description.characters.count > 0 && challengeTime.characters.count > 0 && imgURL.characters.count > 0) {
            DataService.ds.REF_CHALLENGES.childByAutoId().setValue(["title": title ,"description": description,"challengeTime": challengeTime, "imageURL": imgURL, "time": Firebase.ServerValue.timestamp(), "createdBy": currentUser, "logoLocation": self.logoLocation])
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
    override func viewWillAppear(_ animated: Bool) {
        self.reloadInputViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CreateChallengesVC.dismissKeyboard)))
        titleTF.delegate = self
      
        descriptionTextView.delegate = self
        durationTF.delegate = self
        
        self.durationTF.text = ""
        self.descriptionTextView.text = ""
        self.titleTF.text = ""
        
        
        
        
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
        descriptionTextView.resignFirstResponder()
         
        return true
    }
    
    func completeChallenge(id: String, challengeData: Dictionary<String, String>) {
        DataService.ds.createChallenge(challengeID: id, challengeData: challengeData)
        //performSegue(withIdentifier: "backToChallenges", sender: self)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        
        cell.textLabel?.text = "Section \(indexPath.section) Row \(indexPath.row)"
        
        return cell
    }
    
    

    
    
    

    
}



// Handles Logo Image Selection
extension CreateChallengesVC: UIImagePickerControllerDelegate {
    
    
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






