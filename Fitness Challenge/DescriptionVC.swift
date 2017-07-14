//
//  DescriptionVC.swift
//  Fitness Challenge
//
//  Created by Travis Whitten on 12/29/16.
//  Copyright © 2016 Travis Whitten. All rights reserved.
//

import UIKit
import Firebase

class DescriptionVC: UIViewController {

    @IBOutlet weak var viaSegueLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    var date = Date()
    var newTotalTime = 0
    var newCurrentTime = 0
    
    
    
    
    
    @IBAction func joinBtnPresses(_ sender: Any) {
        
        
        if((self.newTotalTime - self.newCurrentTime)  <= 0) {
            let alertController1 = UIAlertController(title: "SORRY", message:"This challenge has ended!", preferredStyle: .alert)
            let OKAction1 = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) in
                
            }
            alertController1.addAction(OKAction1)
            self.present(alertController1, animated: true, completion: nil)
            
        } else {
            
            performSegue(withIdentifier: "joinChallenge", sender: self)
        }
        
        
            }
    
    @IBAction func leaderboardBtnPressed(_ sender: Any) {
        
        //let objLeaderboardVC = LeaderboardsVC()
        //objLeaderboardVC.hidesBottomBarWhenPushed = true
        //self.navigationController?.pushViewController(objLeaderboardVC, animated: false)
        
        performSegue(withIdentifier: "goToLeaderboards", sender: self)
        
    }
    
    var challengeTitle = ""
    var challengeDescription = ""
    var challengeKey = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viaSegueLabel.text = challengeTitle
        descriptionLabel.text = challengeDescription
        print("CHALLENGE SELECTED: \(challengeKey)")
        
        //Navigation Bar Title
        navigationItem.title = "Challenge"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editTapped))

        
        
        DataService.ds.REF_CHALLENGES.child(challengeKey).observeSingleEvent(of:.value, with: {(snapshot) in
            //print("SNAPSHOT: \(snapshot)")
            //print("Description KEY: \(key)")
            let currentTime = Int(self.date.timeIntervalSince1970)
            let timeCreated = ((snapshot.childSnapshot(forPath: "time").value)! as! Int) / 1000
            let desiredTime = (snapshot.childSnapshot(forPath: "challengeTime").value)! as! String
            let intDesiredTime = Int(desiredTime)!
            let desiredTimeInSec = intDesiredTime * 86400
            let totalTime = timeCreated + desiredTimeInSec
            
            //print("TOTAL TIME: \(totalTime)")
            //print("TIME CREATED: \(timeCreated)")
            //print("CURRENT TIME: \(currentTime)")
            
            self.newTotalTime = totalTime
            self.newCurrentTime = timeCreated
            
        })
        
        //This dataservice call is testing to see if the current user created this challenge or not
        let currentUser = Auth.auth().currentUser!.uid 
        DataService.ds.REF_CHALLENGES.child(challengeKey).observeSingleEvent(of: .value, with: {(snapshot) in
            
            let createdBy = snapshot.childSnapshot(forPath: "createdBy").value! as! String
            self.challengeKey = snapshot.key
            //print("CREATED BY USER: \(createdBy)")
            //print("CURRENT USER: \(currentUser)")
            if(createdBy == currentUser) {
                print("This user created it")
                
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            } else {
                
                self.navigationItem.rightBarButtonItem?.isEnabled = false
                print("This user didnt create it")
            }
            
        })

    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "joinChallenge" {
            let destination = segue.destination as! JoinChallengeVC
            
            let challengeTitle = self.challengeTitle
            let challengeDescription = self.challengeDescription
            let challengeKey = self.challengeKey
            
            destination.challengeTitle = challengeTitle
            destination.challengeDescription = challengeDescription
            destination.challengeKey = challengeKey
        } else if segue.identifier == "goToLeaderboards" {
            let destination2 = segue.destination as! LeaderboardsVC
            
            
            let challengeTitle = self.challengeTitle
            let challengeDescription = self.challengeDescription
            let challengeKey = self.challengeKey
            
            destination2.challengeTitle = challengeTitle
            destination2.challengeDescription = challengeDescription
            destination2.challengeKey = challengeKey
            
        } else if segue.identifier == "editChallenge" {
            let destination2 = segue.destination as! editChallengeVC
            
            
           
            let challengeKey = self.challengeKey
            
         
            destination2.challengeKey = challengeKey

        }
    }


    
    func editTapped() {
        
        performSegue(withIdentifier: "editChallenge", sender: self)
        
    }
    
    
    
}
