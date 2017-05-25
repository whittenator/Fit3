//
//  Profile.swift
//  Fitness Challenge
//
//  Created by Travis Whitten on 1/3/17.
//  Copyright © 2017 Travis Whitten. All rights reserved.
//

import Foundation

struct Profile {
    private var _userName: String
    private var _gender: String
    private var _age: String
    private var _bio: String
    private var _weight: String
    private var _profileImg: String
    
    
    var gender: String {
        return _gender
    }
    
    var userName: String {
        return _userName
    }
    
    var age: String {
        return _age
    }
    
    var bio: String {
        return _bio
    }
    
    var weight: String {
        return _weight
    }
    
    var profileImg: String {
        return _profileImg
    }
    
    init(userName: String, gender: String, age: String, bio: String, weight: String, profileImg: String) {
        _userName = userName
        _gender = gender
        _age = age
        _bio = bio
        _weight = weight
        _profileImg = profileImg
        
    }
    
}
