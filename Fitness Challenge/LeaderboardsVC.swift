//
//  LeaderboardsVC.swift
//  Fitness Challenge
//
//  Created by Travis Whitten on 1/2/17.
//  Copyright © 2017 Travis Whitten. All rights reserved.
//

import UIKit
import Firebase


class LeaderboardsVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    

    var maleLeaders = [Leaderboard]()
    var femaleLeaders = [Leaderboard]()
    
    
    var challengeTitle = ""
    var challengeDescription = ""
    var challengeKey = ""
    var videoURL: URL?
    var userName = String()
    
   
    @IBOutlet weak var leaderRank: UILabel!
   
    
    @IBOutlet weak var mySegment: SegmentedControl!
    
    
    
    @IBOutlet var leaderTV: UITableView!
    
    
    @IBAction func backToChallenge(_ sender: Any) {
 
        
        performSegue(withIdentifier: "backToChallenge", sender: self)
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        leaderTV.delegate = self
        leaderTV.dataSource = self
        
        //Making segement controller pretty
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        navigationItem.title = "Leaderboards"
        
        //let currentUser = FIRAuth.auth()!.currentUser!.uid
        
        DataService.ds.REF_LEADERBOARDS.child(self.challengeKey).queryOrdered(byChild: "reps").observe(.value, with: { (snapshot) in
            
            self.maleLeaders = []
            self.femaleLeaders = []
            
           // print("WHITTEN: \(snapshot)")
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshots {
                    //print("SNAP: \(snap)")
                    if let leaderDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let gender = snap.childSnapshot(forPath: "gender")
                        //print("WHITTEN GENDER: \(gender)")
                        if gender.value as? String == "Male" {
                        //print("This is the key\(key)")
                            //print("YO WHITTEN: THIS PERSON IS A MALE!!")
                        
                        let leader = Leaderboard(userKey: key, leaderData: leaderDict)
                            print("LEADER: \(leader)")
                        
                        self.maleLeaders.append(leader)
                        } else {
                            //print("YO WHITTEN: THIS IS A FEMALE!")
                            let leader2 = Leaderboard(userKey: key, leaderData: leaderDict)
                            self.femaleLeaders.append(leader2)
                        }
                        
                    }
                }
            }
            self.femaleLeaders.reverse()
            self.maleLeaders.reverse()
            self.leaderTV.reloadData()
        })
      
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        var returnValue = 0
        
        switch (mySegment.selectedIndex) {
        case 0:
            returnValue = maleLeaders.count
            break
        case 1:
            returnValue = femaleLeaders.count
            break
            
        default:
            break
            
        }
        return returnValue
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        switch (mySegment.selectedIndex) {
        case 0:
            let leader = maleLeaders[indexPath.row]
            performSegue(withIdentifier: "VideoVC", sender: leader)
            break
        case 1:
            let leader2 = femaleLeaders[indexPath.row]
            performSegue(withIdentifier: "VideoVC", sender: leader2)
            break
            
        default:
            break
            
        }

        
        
        
        //performSegue(withIdentifier: "VideoVC", sender: leader)
        print("You selected row #\(indexPath.row)!")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardsCell") as? LeaderboardsCell
            //cell.configureCell(leader: leader)
        
        switch (mySegment.selectedIndex) {
        case 0:
            let leader = maleLeaders[indexPath.row]
            cell?.rankLbl.text = ("\(indexPath.row + 1)")
            cell!.configureCell(leader: leader)
            
            break
        case 1:
            let leader2 = femaleLeaders[indexPath.row]
            cell?.rankLbl.text = ("\(indexPath.row + 1)")
            cell!.configureCell(leader: leader2)
            break
            
        default:
            break
            
        }
        
           return cell!
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let message = UITableViewRowAction(style: .normal, title: "Message", handler:  {action, index in
            //TODO: Take User to the message platform 
            if (self.mySegment.selectedIndex == 0) {
            let leader = self.maleLeaders[indexPath.row]
            self.performSegue(withIdentifier: "CreateMessage", sender: leader)
            } else {
                let leader = self.femaleLeaders[indexPath.row]
                self.performSegue(withIdentifier: "CreateMessage", sender: leader)
            }
        })
        message.backgroundColor = UIColor.lightGray
        
        return [message]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? VideoVC {
            
            if let video = sender as? Leaderboard {
                destination.videoLink = video
            }
            if let challengeID = sender as? Leaderboard {
                destination.userKey = challengeID
            }
            if let challengeKey = sender as? Leaderboard {
                destination.challengeKey = challengeKey
            }
            
        }
        if let destination2 = segue.destination as? DescriptionVC {
            destination2.challengeTitle = challengeTitle
            destination2.challengeDescription = challengeDescription
            destination2.challengeKey = challengeKey

        }
        
        if let destination3 = segue.destination as? MessagesVC {
            
            
            if let userKey = sender as? Leaderboard {
                destination3.userKey = userKey
            }
            
            
        }
        
    }
    
    
    @IBAction func segmentControlChanged(_ sender: Any) {
        
        leaderTV.reloadData()
        
    }
    
    
    
    
    


}
