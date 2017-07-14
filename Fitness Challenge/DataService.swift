//
//  DataService.swift
//  Fitness Challenge
//
//  Created by Travis Whitten on 12/20/16.
//  Copyright © 2016 Travis Whitten. All rights reserved.
//

import Foundation
import FirebaseDatabase
import SwiftKeychainWrapper
import FirebaseStorage

let FIR_CHILD_USERS = "users"
let DB_BASE = Database.database().reference()
let STORAGE_BASE = Storage.storage().reference()

class DataService {
    
    // DB References
    private var _REF_BASE = DB_BASE
    private var _REF_CHALLENGES = DB_BASE.child("challenge")
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_JOINEDCHALLENGES = DB_BASE.child("joinedChallenge")
    private var _REF_LEADERBOARDS = DB_BASE.child("leaderboards")
    private var _REF_VIDEO_LIST = DB_BASE.child("videoList")
    private var _REF_REPORTS = DB_BASE.child("reports")
    private var _REF_MESSAGES = DB_BASE.child("messages")
    private var _REF_PROFILE = DB_BASE.child("users").child("profile")
    // Storage References
    private var _STORAGE_VIDEOS = STORAGE_BASE.child("videos")
    private var _STORAGE_LOGOS = STORAGE_BASE.child("images/challengeLogos")
    private var _STORAGE_PROFILE_IMAGES = STORAGE_BASE.child("images/profilePictures")
    
    // DB Getters
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    var REF_LEADERBOARDS: DatabaseReference {
        return _REF_LEADERBOARDS
    }
    
    var REF_CHALLENGES: DatabaseReference {
        return _REF_CHALLENGES
    }
    
    var REF_JOINEDCHALLENGES: DatabaseReference {
        return _REF_JOINEDCHALLENGES
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_VIDEO_LIST: DatabaseReference {
        return _REF_VIDEO_LIST
    }
    
    var REF_REPORTS: DatabaseReference {
        return _REF_REPORTS
    }
    
    var REF_MESSAGES: DatabaseReference {
        return _REF_MESSAGES
    }
    
    var REF_PROFILE: DatabaseReference {
        return _REF_PROFILE
    }
    
    var REF_USER_CURRENT: DatabaseReference {
        let uid = KeychainWrapper.standard.string(forKey: KEY_UID)
        let user = REF_USERS.child(uid!)
        return user
    }
    
    // Storage Getters
    var STORAGE_VIDEOS: StorageReference {
        return _STORAGE_VIDEOS
    }
    
    var STORAGE_LOGOS: StorageReference {
        return _STORAGE_LOGOS
    }
    
    var STORAGE_PROFILE_IMAGES: StorageReference {
        return _STORAGE_PROFILE_IMAGES
    }
    
    static let ds = DataService()
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func createChallenge(challengeID: String, challengeData: Dictionary<String, String>) {
        REF_CHALLENGES.child(challengeID).updateChildValues(challengeData)
    }
    
    func joinChallenge(challengeID: String, joinedData: Dictionary<String, AnyObject>) {
        REF_JOINEDCHALLENGES.child(challengeID).updateChildValues(joinedData)
    }
    
    func createReporter(challengeKey: String ,uid: String,reporter: String ,reportData: Dictionary<String,String>) {
        REF_REPORTS.child(uid).updateChildValues(reportData)
    }
    
}

