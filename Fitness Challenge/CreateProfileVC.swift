//
//  CreateProfileVC.swift
//  Fitness Challenge
//
//  Created by Travis Whitten on 1/3/17.
//  Copyright © 2017 Travis Whitten. All rights reserved.
//

import UIKit
import Firebase

class CreateProfileVC: UIViewController {
    
    @IBOutlet weak var usernameTF: UITextField!
    
    @IBOutlet weak var bioTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    
    @IBOutlet weak var ageTF: UITextField!
    @IBOutlet weak var genderTF: UITextField!
    
    @IBOutlet weak var weightTF: UITextField!
    
    
    
    
    @IBAction func applyBtnPressed(_ sender: Any) {
    
        
        let username = usernameTF.text
        let bio = bioTF.text
        let name = nameTF.text
        let age = ageTF.text
        let gender = genderTF.text
        let weight = weightTF.text
        
        if ((username?.characters.count)! > 0 && (gender?.characters.count)! > 0) {


    DataService.ds.REF_USERS.child(Auth.auth().currentUser!.uid).child("profile").setValue(["userName": username ,"bio": bio, "name": name, "age": age, "gender":gender,"weight": weight])
        
        
        } else {
            mustEnterUsername()
        }
        performSegue(withIdentifier: "backToProfile", sender: nil)
    
    }
    
    func mustEnterUsername() {
        let alertController2 = UIAlertController(title: "ERROR", message:"Must enter a username and gender!", preferredStyle: .alert)
        let OKAction2 = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) in
            print("You've pressed OK button");
            
        }
        alertController2.addAction(OKAction2)
        self.present(alertController2, animated: true, completion: nil)
        
    }
    

    


    override func viewDidLoad() {
        super.viewDidLoad()

            self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CreateProfileVC.dismissKeyboard)))
        
        fillProfileTF()
        
    }
    
    func fillProfileTF() {
        DataService.ds.REF_USERS.child(Auth.auth().currentUser!.uid).child("profile").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.usernameTF.text = dictionary["userName"] as? String
                self.genderTF.text = dictionary["gender"] as? String
                self.ageTF.text = dictionary["age"] as? String
                self.bioTF.text = dictionary["bio"] as? String
                self.weightTF.text = dictionary["weight"] as? String
                self.nameTF.text = dictionary["name"] as? String
                
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
        ageTF.resignFirstResponder()
        genderTF.resignFirstResponder()
        weightTF.resignFirstResponder()
        return true
    }
    
    


}
