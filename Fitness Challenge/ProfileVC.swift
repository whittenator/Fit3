//
//  CreateProfileVC.swift
//  Fitness Challenge
//
//  Created by Travis Whitten on 12/13/16.
//  Copyright © 2016 Travis Whitten. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class ProfileVC: UIViewController{
    
    var username = ""
    var name = ""
    var gender = ""
    var age = ""
    var bio = ""
    var weight = ""
    
    
   
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var bioLbl: UILabel!
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var genderLbl: UILabel!
    
    @IBOutlet weak var profileImg: UIImageView!
    
   
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
   
    
    @IBAction func signOutPressed(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            performSegue(withIdentifier: "goToSignUp", sender: nil)
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError.localizedDescription)")
        }
        
    }
    
    @IBAction func messagesPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "goToMessages", sender: nil)
        
    }
   
    
    @IBAction func editPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "editProfile", sender: self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parseForProfile()
        
        //Rounds the profile image
        
        profileImg.layer.cornerRadius = profileImg.frame.size.height/2
        profileImg.contentMode = .scaleAspectFill
        profileImg.clipsToBounds = true
        profileImg.layer.borderWidth = 3
        profileImg.layer.borderColor = UIColor.white.cgColor
    
        let currentUser = Auth.auth().currentUser!.uid
        DataService.ds.REF_USERS.child(currentUser).observeSingleEvent(of: .value, with: {(snapshot) in
            
            let isAdmin = snapshot.childSnapshot(forPath: "isAdmin").value! as! Bool
            if(isAdmin == false) {
                //print("THIS IS NOT AN ADMIN!")
                let items = self.tabBarController?.tabBar.items
                let tabItem = items![2]
                tabItem.isEnabled = false
            } else {
                print("THIS PERSON IS AN ADMIN")
            }
            
            
        })
        
        
        


        
        
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        navigationItem.backBarButtonItem?.tintColor = UIColor.init(red: 0.40, green: 0.85, blue: 1.0, alpha: 1.0)
    }
    
    
    func parseForProfile() {
        DataService.ds.REF_USERS.child((Auth.auth().currentUser?.uid)!).child("profile").observe(.value, with: {(snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.usernameLbl.text = dictionary["userName"] as? String
                self.genderLbl.text = dictionary["gender"] as? String
                self.ageLbl.text = dictionary["age"] as? String
                self.bioLbl.text = dictionary["bio"] as? String
                self.weightLbl.text = dictionary["weight"] as? String
                self.heightLbl.text = dictionary["name"] as? String
                //self.profileImg = dictionary["profileImg"] as! UIImageView
                let stringURL = NSURL(string: dictionary["profileImg"] as! String)
                self.profileImg.sd_setImage(with: stringURL as URL?)
                
            }
            
        }, withCancel: nil)
    }

    
    
    

}
