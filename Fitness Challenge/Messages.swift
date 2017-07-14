//
//  Messages.swift
//  Fitness Challenge
//
//  Created by Travis Whitten on 6/22/17.
//  Copyright © 2017 Travis Whitten. All rights reserved.
//

import Foundation

class Messages {
    
    private var _messageKey: String!
    private var _username: String!
    private var _timeStamp: String!
    private var _text: String!
    private var _photoURL: String!
    private var _userID: String!
 
    
    
    var messageKey: String {
        return _messageKey
    }
    
    var username: String {
        return _username
    }
    
    var timeStamp: String {
        return _timeStamp
    }
    
    var text: String {
        return _text
    }
    
    var photoURL: String {
        return _photoURL
    }
    
    var userID: String {
        return _userID
    }
    
    
    
    
    
    init(messageKey: String, messageData: Dictionary<String, AnyObject>) {
        self._messageKey = messageKey
        
        if let username = messageData["username"] as? String {
            self._username = username
        }
        if let timeStamp = messageData["timeStamp"] as? String {
            self._timeStamp = timeStamp
        }
        if let text = messageData["text"] as? String {
            self._text = text
        }
        if let photoURL = messageData["photoURL"] as? String {
            self._photoURL = photoURL
        }
        if let userID = messageData["userID"] as? String {
            self._userID = userID
        }
        
        
    }
    
    
}

