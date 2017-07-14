//
//  ProfileImgVC.swift
//  Fitness Challenge
//
//  Created by Travis Whitten on 6/6/17.
//  Copyright © 2017 Travis Whitten. All rights reserved.
//

import UIKit

class ProfileImgVC: UIViewController {
    
    var username = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       
    }
    override func viewDidAppear(_ animated: Bool) {
        print("\(self.username)")
    }

    
}
