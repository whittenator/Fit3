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
    
        
       
        
        
        


        
        
        
        
        
    }
    
    
    func parseForProfile() {
        DataService.ds.REF_USERS.child((Auth.auth().currentUser?.uid)!).child("profile").observeSingleEvent(of: .value, with: { (snapshot) in
            
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
