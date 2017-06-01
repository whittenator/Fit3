//
//  Challenge.swift
//  Fitness Challenge
//
//  Created by Travis Whitten on 12/29/16.
//  Copyright © 2016 Travis Whitten. All rights reserved.
//

import Foundation

class Challenge {
    private var _title: String!
    private var _description: String!
    private var _challengeKey: String!
    private var _logoLink: String!
    private var _challengeTime: String!
    private var _stampTime: Int!
    private var _usersJoined: Int!
    private var _createBy: String!
    private var _videoID: String!
    private var _logoLocation: String!
    
    var title: String {
        return _title
    }
    
    var description: String {
        return _description
    }
    
    var challengeKey: String {
        return _challengeKey
    }
    
    var logoLink: String {
        return _logoLink
    }
    
    var challengeTime: String {
        return _challengeTime
    }
    
    var stampTime: Int {
        return _stampTime
    }
    
    var usersJoined: Int {
        return _usersJoined
    }
    
    var createdBy: String {
        return _createBy
    }
    
    var videoID: String {
        return _videoID
    }
    
    var logoLocation: String {
        return _logoLocation
    }
    
    init(title: String, description: String) {
        self._title = title
        self._description = description
    }
    
    init(challengeKey: String, challengeData: Dictionary<String, AnyObject>) {
        self._challengeKey = challengeKey
        
        
        if let description = challengeData["description"] as? String {
            self._description = description
        }
        if let title = challengeData["title"] as? String {
            self._title = title
        }
        if let logoLink = challengeData["imageURL"] as? String {
            self._logoLink = logoLink
        }
        if let challengeTime = challengeData["challengeTime"] as? String {
            self._challengeTime = challengeTime
        }
        if let stampTime = challengeData["time"] as? Int {
            self._stampTime = stampTime
        }
        if let usersJoined = challengeData["usersJoined"] as? Int {
            self._usersJoined = usersJoined
        }
        if let createdBy = challengeData["createdBy"] as? String {
            self._createBy = createdBy
        }
        if let videoID = challengeData["videoID"] as? String  {
            self._videoID = videoID
        }
        
        if let logoLocation = challengeData["logoLocation"] as? String {
            self._logoLocation = logoLocation
        }
        
    }
    
}
