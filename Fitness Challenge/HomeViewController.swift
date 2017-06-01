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
    
    
    @IBOutlet weak var segmentBar: UISegmentedControl!
    
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
    
    //If Top Challenges button is selected
    
    
    
    
   
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
        
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
                        
                        //print("\(snap.key)")
                        //print("USERS JOINED: \(usersJoined)")
                        
                        
                        
                        if(intDate >= totalTime ) {
                            
                          
                            
                        } else {
                            let newChallenge2 = Challenge(challengeKey: key, challengeData: challengeDict)
                            self.newChallenges.append(newChallenge2)
                            self.tableView.reloadData()
                           
                        }
                        
                    }
                }
            }
            self.newChallenges.reverse()
            self.tableView.reloadData()
            
        })
        self.tableView.reloadData()
        
        //Query 1 shows Top Challenges based on Total users joined
        let query1 = DataService.ds.REF_CHALLENGES.queryOrdered(byChild: "usersJoined")
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
                        
                        
                        
                        
                        
                        
                        
                        
                        //print("USERS JOINED: \(usersJoined)")
                        
                        //print("\(intDate)")
                        //print("\(totalTime)")
                        if(intDate >= totalTime ) {
                           
                            
                        } else {
                            let topChallenge2 = Challenge(challengeKey: key, challengeData: challengeDict)
                            self.topChallenges.append(topChallenge2)
                            self.tableView.reloadData()
                        }
                    }
                }
            }
            self.topChallenges.reverse()
            self.tableView.reloadData()
            
        })
        self.tableView.reloadData()
        //Gets all completed challenges and puts them in Finished Challenges
        //let currentUser = Auth.auth().currentUser!.uid
        let query3 = DataService.ds.REF_CHALLENGES.queryLimited(toLast: 10)
        query3.observe(.value, with: { (snapshot) in
            
            self.finishedChallenges = []
            
            
            //let currentUser = Auth.auth().currentUser!.uid
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    
                    
                    
                    if let challengeDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let newKey = snap.childSnapshot(forPath: "joinedChallenger")
                        let vidVal = newKey.key
                        
                        //Delete storage video
                        DataService.ds.REF_LEADERBOARDS.child(key).observeSingleEvent(of: .value, with: {(dataSnap) in
                            if let snapshots = dataSnap.children.allObjects as? [DataSnapshot]{
                                for snap in snapshots {
                                    //print("SNAP: \(snap)")
                                    if let leaderDict = snap.value as? Dictionary<String, AnyObject> {
                                        let key = snap.key
                                        self.vidKey = snap.childSnapshot(forPath: "videoID").value! as! String
                                        let vidLink = snap.childSnapshot(forPath: "videoLink").value! as! String
                                        
                                        
                                        // print("USER ID: \(key)")
                                        //print("VIDEO ID: \(self.vidKey)")
                                        
                                        
                                        
                                    }
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
                        
                       
                        
                        
                        if((totalTime - intDate) <= 0) {
                            let yourChallenge = Challenge(challengeKey: key, challengeData: challengeDict)
                            self.finishedChallenges.append(yourChallenge)
                            self.tableView.reloadData()
                            //print("TOTAL TIME: \(totalTime)")
                            //print("CURRENT TIME: \(intDate)")
                            //print("3 Hours after TOTAL TIME: \(totalTime + (3*3600))")
                            
                            
                            
                            
                        }
                        
                        
                        if ((totalTime - intDate) <= 0 && ((totalTime + (15 * 86400) ) <= intDate)) {
                            
                            
                            //Deletes challenge from database
                            self.challengeBase.child(key).removeValue(completionBlock: {(error, ref) in
                                if error != nil {
                                    print("error \(String(describing: error))")
                                } else {
                                    print("DELETED CHALLENGE")
                                }
                            })
                            self.tableView.reloadData()
                            
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
                            self.tableView.reloadData()
                            
                            
                            
                        }
                    }
                }
            }
            self.finishedChallenges.reverse()
            self.tableView.reloadData()
            
            
        })
        self.tableView.reloadData()

        
    }
    
    func refresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        if #available(iOS 10.0, *) {
        tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        //Adds Refresh spinner if table view is pulled up
        refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.black
        refreshControl.tintColor = UIColor.white
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        
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
    
    //Function to remove firebase nodes
    /*
    func deleteNodes(removeChild: String) {
        challengeBase.child(removeChild).removeValue(completionBlock: { (error, ref) in
            if (error != nil) {
                print("error \(String(describing: error))")
            }
    })
}*/
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
    
    
        
        
    
    
  
    
    
    
    
    
}
