//
//  HomeViewController.swift
//  Fitness Challenge
//
//  Created by Travis Whitten on 12/29/16.
//  Copyright © 2016 Travis Whitten. All rights reserved.
//

import UIKit
import Firebase
import PullToRefresh

class HomeViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UINavigationBarDelegate, UINavigationControllerDelegate {
    
    
   
    @IBOutlet weak var segmentBar2: UISegmentedControl!
    @IBOutlet weak var segmentBar: SegmentedControlHome!
    @IBOutlet weak var editChallenge: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    var newChallenges = [Challenge]()
    var topChallenges = [Challenge]()
    var finishedChallenges = [Challenge]()
    
     var date = Date()
    var refreshControl: UIRefreshControl!
    
    var challengeBase = DataService.ds.REF_CHALLENGES
    var leaderboardBase = DataService.ds.REF_LEADERBOARDS
    var logoStorage = DataService.ds.STORAGE_LOGOS
    var videoStorage = DataService.ds.STORAGE_VIDEOS
    
    var vidKey = ""
    
    
    @IBOutlet weak var homeButton: UIBarButtonItem!
    @IBAction func unwindToHomeVC(segue: UIStoryboardSegue) {}
    
    //If Top Challenges button is selected
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        
        
        //Hiding create challenges from non admins
        let currentUser = Auth.auth().currentUser!.uid
        DataService.ds.REF_USERS.child(currentUser).observeSingleEvent(of: .value, with: {(snapshot) in

            let isAdmin = snapshot.childSnapshot(forPath: "isAdmin").value! as! Bool
            if(isAdmin == false) {
                //print("THIS IS NOT AN ADMIN!")
                let items = self.tabBarController?.tabBar.items
                let tabItem = items![2]
                tabItem.isEnabled = false
            } else {
            //print("THIS PERSON IS AN ADMIN")
            }
            
            
        })
        
        //Query2 gets Newly Made challenges based on time of creation
        let query2 = DataService.ds.REF_CHALLENGES.queryOrdered(byChild: "time")
        query2.observe(.value, with: { (snapshot) in
            
            self.newChallenges = []
            
            
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
                        
                        
                        
                        
                        if(intDate >= totalTime ) {
                            
                            
                            
                        } else {
                            let newChallenge2 = Challenge(challengeKey: key, challengeData: challengeDict)
                            self.newChallenges.append(newChallenge2)
                            
                            
                        }
                        
                    }
                }
                self.newChallenges.reverse()
                self.tableView.reloadData()
            }
            
            
        })
        
        //Query 1 shows Top Challenges based on Total users joined
        let query1 = DataService.ds.REF_CHALLENGES.queryOrdered(byChild: "usersJoined").queryLimited(toFirst: 20)
        query1.observe(.value, with: { (snapshot) in
            
            self.topChallenges = []
            
            
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
                        
                        if(intDate >= totalTime ) {
                            self.tableView.reloadData()
                            
                        } else {
                            let topChallenge2 = Challenge(challengeKey: key, challengeData: challengeDict)
                            self.topChallenges.append(topChallenge2)
                            //self.topChallenges.reverse()
                            //self.tableView.reloadData()
                            
                        }
                    }
                }
                self.topChallenges.reverse()
                self.tableView.reloadData()
            }
            
            
        })
      
      
        
        
        //Gets all completed challenges and puts them in Finished Challenges
        //let currentUser = Auth.auth().currentUser!.uid
        let query3 = DataService.ds.REF_CHALLENGES.queryLimited(toFirst: 20)
        query3.observe(.value, with: { (snapshot) in
            
            self.finishedChallenges = []
            
            
            //let currentUser = Auth.auth().currentUser!.uid
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    
                    
                    
                    if let challengeDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                       

                        
                      
                        DataService.ds.REF_LEADERBOARDS.child(key).observeSingleEvent(of: .value, with: {(dataSnap) in
                            if let snapshots = dataSnap.children.allObjects as? [DataSnapshot]{
                                for snap in snapshots {
                                    //print("SNAP: \(snap)")
                                  
                                      
                                        self.vidKey = snap.childSnapshot(forPath: "videoID").value! as! String
                                       
                                        
                                        
                                        
                                    
                                }
                            }
                            
                            
                        })
                        
                        
                        
                        let newDate = self.date.timeIntervalSince1970
                        let intDate = Int(newDate)
                        let timeCreated = (snap.childSnapshot(forPath: "time").value)!
                        let desiredTime = (snap.childSnapshot(forPath: "challengeTime").value)!
                        let intCreated = timeCreated as! Int
                        let stringDesired = desiredTime as! String
                        let intDesired = Int(stringDesired)!
                        let desiredTimeSec = (intDesired * 86400)
                        let totalTime = ((intCreated/1000) + desiredTimeSec)
                        
                        
                        
                        print("TOTAL TIME: \(totalTime)")
                        print("INT DATE: \(intDate)")
                        if(intDate > totalTime) {
                            let yourChallenge3 = Challenge(challengeKey: key, challengeData: challengeDict)
                            self.finishedChallenges.append(yourChallenge3)
                            self.tableView.reloadData()
                       
                            
                            
                            
                            
                        }
                        
                        if ((intDate > totalTime) && ((totalTime + (15 * 86400) ) <= intDate)) {
                            
                            
                            //Deletes challenge from database
                            self.challengeBase.child(key).removeValue(completionBlock: {(error, ref) in
                                if error != nil {
                                    print("error \(String(describing: error))")
                                } else {
                                    print("DELETED CHALLENGE")
                                }
                            })
                            
                            
                            //Delete Storage Logo of Challenge
                            let logoURL = snap.childSnapshot(forPath: "logoLocation").value!
                            print("LOGO PATH: \(logoURL)")
                            self.deleteLogoFile(ref: logoURL as! String, vidRef: self.vidKey)
                            
                            
                            //Deletes leaderboard data from database
                            self.leaderboardBase.child(key).removeValue(completionBlock: {(error, ref) in
                                if error != nil {
                                    print("error \(String(describing: error))")
                                } else {
                                    print("DELETED LEADERBOARD")
                                }
                            })
                            
                            
                            
                        }
                    }
                }
                self.finishedChallenges.reverse()
                self.tableView.reloadData()

            }
            
            
        })
        
      
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var returnValue = 0
        
        switch(segmentBar.selectedIndex) {
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
        print("You selected row #\(indexPath.row)!")
        
        switch (segmentBar.selectedIndex) {
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
        cell?.layer.backgroundColor = UIColor.clear.cgColor
        switch (segmentBar.selectedIndex) {
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
            navigationItem.backBarButtonItem?.tintColor = UIColor.init(red: 0.40, green: 0.85, blue: 1.0, alpha: 1.0)
        
        if segue.identifier == "goToChallenge" {
            let destination = segue.destination as! DescriptionTVC
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                if segmentBar.selectedIndex == 0 {
                    let theTitle = topChallenges[indexPath.row]
                    destination.challengeTitle = theTitle.title
                    destination.challengeDescription = theTitle.description
                    destination.challengeRules = theTitle.rules
                    destination.challengePrizes = theTitle.prizes
                    destination.challengeKey = theTitle.challengeKey
                    destination.challengeLogo = theTitle.logoLink
                } else if (segmentBar.selectedIndex == 1) {
                let theTitle = newChallenges[indexPath.row]
                destination.challengeTitle = theTitle.title
                destination.challengeDescription = theTitle.description
                    destination.challengeRules = theTitle.rules
                    destination.challengePrizes = theTitle.prizes
                destination.challengeKey = theTitle.challengeKey
                    destination.challengeLogo = theTitle.logoLink
                } else {
                    let theTitle = finishedChallenges[indexPath.row]
                    destination.challengeTitle = theTitle.title
                    destination.challengeDescription = theTitle.description
                    destination.challengeRules = theTitle.rules
                    destination.challengePrizes = theTitle.prizes
                    destination.challengeKey = theTitle.challengeKey
                    destination.challengeLogo = theTitle.logoLink

                }
            }
                
            
                
            
        }
    }
    
    @IBAction func segmentValueChanged(_ sender: Any) {
        
        tableView.reloadData()
        
    }
    
       func deleteLogoFile(ref: String, vidRef: String) {
        
        let newRef = DataService.ds.STORAGE_LOGOS.child(ref)
        let videoRef = Storage.storage().reference().child("\(vidRef)")
        
        newRef.delete(completion: {(error) in
            if (error != nil) {
            print("ERROR DELETING LOGO: \(String(describing: error))")
            } else {
                print("SUCCESSFULLY DELETED LOGO")
            }
        })
        
        videoRef.delete(completion: {(error2) in
            if (error2 != nil) {
                print("ERROR DELETING VIDEO: \(String(describing: error2))")
            } else {
                print("SUCCESSFULLY DELETED VIDEO")
            }
            
            
            
        })
        
        
        
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {}
    
    
        
        
    
    
  
    
    
    
    
    
}

