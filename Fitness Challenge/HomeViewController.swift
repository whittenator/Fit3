//
//  HomeViewController.swift
//  Fitness Challenge
//
//  Created by Travis Whitten on 12/29/16.
//  Copyright © 2016 Travis Whitten. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UINavigationBarDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var segmentBar: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    var newChallenges = [Challenge]()
    var topChallenges = [Challenge]()
    var finishedChallenges = [Challenge]()
    
     var date = Date()
    
    
    @IBOutlet weak var homeButton: UIBarButtonItem!
    
    //If Top Challenges button is selected
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
       /*
        //Getting database references
        DataService.ds.REF_CHALLENGES.observe(.value, with: { (snapshot) in
            
            self.challenges = [] //clears out challenges array at the beginning of listener
            self.topChallenges = []
            
            print(snapshot.value!)
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    //print("SNAP: \(snap)")
                    if let challengeDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let usersJoined = snap.childSnapshot(forPath: "joinedChallenger").childrenCount
                        let challenge = Challenge(challengeKey: key, challengeData: challengeDict)
                        self.challenges.append(challenge)
                    }
                }
            }
            self.tableView.reloadData()
        })
        */
        
        //Query2 gets Newly Made challenges based on time of creation
        let query2 = DataService.ds.REF_CHALLENGES.queryOrdered(byChild: "time").queryLimited(toLast: 10)
        query2.observe(.value, with: { (snapshot) in
            
            self.newChallenges = []
            
            
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    if let challengeDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        print("\(snap.key)")
                        //print("USERS JOINED: \(usersJoined)")
                        
                        let newChallenge = Challenge(challengeKey: key, challengeData: challengeDict)
                        self.newChallenges.append(newChallenge)
                    }
                }
            }
            self.newChallenges.reverse()
            self.tableView.reloadData()
        
        })
        
        //Query 1 shows Top Challenges based on Total users joined
        let query1 = DataService.ds.REF_CHALLENGES.queryOrdered(byChild: "usersJoined").queryLimited(toLast: 10)
        query1.observe(.value, with: { (snapshot) in
            
            self.topChallenges = []
            
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    if let challengeDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                       
                        //print("USERS JOINED: \(usersJoined)")
                        
                        let topChallenge = Challenge(challengeKey: key, challengeData: challengeDict)
                        self.topChallenges.append(topChallenge)
                    }
                }
            }
            self.topChallenges.reverse()
            self.tableView.reloadData()
            
        })
        
        //Gets all completed challenges and puts them in Finished Challenges
       //let currentUser = Auth.auth().currentUser!.uid
        let query3 = DataService.ds.REF_CHALLENGES.queryLimited(toLast: 10)
        query3.observe(.value, with: { (snapshot) in
            
            self.finishedChallenges = []
            
            
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    if let challengeDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let newDate = self.date.timeIntervalSince1970
                        let intDate = Int(newDate)
                        let timeCreated = (snap.childSnapshot(forPath: "time").value)!
                        let desiredTime = (snap.childSnapshot(forPath: "challengeTime").value)!
                        let intCreated = timeCreated as! Int
                        let stringDesired = desiredTime as! String
                        let intDesired = Int(stringDesired)!
                        let desiredTimeSec = (intDesired * 86400)
                        let totalTime = ((intCreated/1000) + desiredTimeSec)
                        
                        let futureDate = Date(timeIntervalSince1970: TimeInterval(totalTime))
                        
                        //print("Current Date Time: \(String(describing: intDate))")
                        //print("Total Time: \(totalTime)")
                        print("Future Date: \(futureDate)")
                        print("Current Date: \(self.date)")
                        //print("USERS JOINED: \(usersJoined)")
                        
                        if((totalTime - intDate) <= 0) {
                            let yourChallenge = Challenge(challengeKey: key, challengeData: challengeDict)
                            self.finishedChallenges.append(yourChallenge)
                        }
                    }
                }
            }
            self.finishedChallenges.reverse()
            self.tableView.reloadData()
            
        })

        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var returnValue = 0
        
        switch(segmentBar.selectedSegmentIndex) {
        case 0:
            returnValue = topChallenges.count
            break
        case 1:
            returnValue = newChallenges.count
            break
        case 2:
            returnValue = finishedChallenges.count
        default:
            break
        }
        
        return returnValue
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("You selected row #\(indexPath.row)!")
        
        switch (segmentBar.selectedSegmentIndex) {
        case 0:
            let challenge1 = topChallenges[indexPath.row]
            self.performSegue(withIdentifier: "goToChallenge", sender: challenge1)
            break
        case 1:
              let challenge2 = newChallenges[indexPath.row]
              self.performSegue(withIdentifier: "goToChallenge", sender: challenge2)
            break
        case 2:
             let challenge3 = finishedChallenges[indexPath.row]
            self.performSegue(withIdentifier: "goToChallenge", sender: challenge3)
        default:
            break
        }

        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        //let challenge = newChallenges[indexPath.row]
        
         let cell = tableView.dequeueReusableCell(withIdentifier: "ChallengesCell") as? ChallengesCell
          //cell.configureCell(challenge: challenge)
        
        switch (segmentBar.selectedSegmentIndex) {
        case 0:
            let challenge1 = topChallenges[indexPath.row]
            cell!.configureCell(challenge: challenge1)
            break
        case 1:
            let challenge2 = newChallenges[indexPath.row]
            cell!.configureCell(challenge: challenge2)
            break
        case 2:
            let challenge3 = finishedChallenges[indexPath.row]
            cell!.configureCell(challenge: challenge3)
        default:
            break
        }

        return cell!
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToChallenge" {
            let destination = segue.destination as! DescriptionVC
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let theTitle = newChallenges[indexPath.row]
                destination.challengeTitle = theTitle.title
                destination.challengeDescription = theTitle.description
                destination.challengeKey = theTitle.challengeKey
            }
        
    
        
                
                //destination.viaSegue =
                
            
        }
    }
    
    @IBAction func segmentValueChanged(_ sender: Any) {
        
        tableView.reloadData()
        
    }
    
    
    
    
    
}
