//
//  usernameVC.swift
//  Fitness Challenge
//
//  Created by Travis Whitten on 6/6/17.
//  Copyright © 2017 Travis Whitten. All rights reserved.
//

import UIKit

class usernameVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTF: UITextField!
    var username = ""
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        

        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        usernameTF.delegate = self
    }
    
   

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let profileImgVC = segue.destination as? ProfileImgVC {
            profileImgVC.username = usernameTF.text!
        }
    }
    

    

}
