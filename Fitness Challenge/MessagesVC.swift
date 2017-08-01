//
//  CreateMessageVC.swift
//  Fitness Challenge
//
//  Created by Travis Whitten on 6/22/17.
//  Copyright © 2017 Travis Whitten. All rights reserved.
//

import UIKit
import Firebase

class MessagesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var messageTV: UITableView!
    private var _userKey: Leaderboard!
    var stringUserName = ""
    var lastMessage = [Messages]()
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        
    performSegue(withIdentifier: "backToProfile", sender: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTV.dataSource = self
        messageTV.delegate = self
        let currentUser = Auth.auth().currentUser!.uid
        
        //TODO: List Messages in a Table View by messages last sent(time stamped)
        DataService.ds.REF_USERS.child(currentUser).child("messages").queryOrderedByKey().observeSingleEvent(of: .value, with: {(snapshot) in

            //print("\(snapshot)")
            self.lastMessage = []
            
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    //print("SNAP: \(snap)")
                    var key = snap.key
                    //print("KEYS: \(key)")
                    DataService.ds.REF_USERS.child(currentUser).child("messages").child(key).queryOrderedByKey().queryLimited(toLast: 1).observeSingleEvent(of: .value, with: {(snapshot2) in
    
                        if let snapshots2 = snapshot2.children.allObjects as? [DataSnapshot] {
                            for snap2 in snapshots2 {
                                
                        
                        if let messageDict = snap2.value as? Dictionary<String, AnyObject> {
                            let key2 = snap2.key
                            //print("KEY2: \(key2)")
                            //let message1 = (snap2.childSnapshot(forPath: "text").value as? String)!
                            //print("TEXT: \(message1)")
                            //print("MESSAGEDICT: \(messageDict)")
                            let message = Messages(messageKey: key2, messageData: messageDict)
                            
                            self.lastMessage.append(message)
                        }
                        }
                        }
                         self.messageTV.reloadData()
                    })
                }
            }
            
            self.messageTV.reloadData()
           
            
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newMessage = lastMessage[indexPath.row]
        
        performSegue(withIdentifier: "CreateMessage", sender: newMessage)
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lastMessage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessagesTVC") as? MessagesTVC
        
        let newMessage = lastMessage[indexPath.row]
        cell!.configureCell(messages: newMessage)
        
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CreateAMessageVC {
            
            if let userID = sender as? Messages {
                destination.userKey = userID.userID
            }
            
        }
    }

   
}
