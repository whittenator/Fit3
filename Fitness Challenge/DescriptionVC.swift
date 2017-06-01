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
        
        
        //print("NEW TOTAL TIME: \(self.newTotalTime)")
        //print("NEW TOTAL TIME: \(self.newCurrentTime)")
        
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
        print(challengeKey)
        
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

        
       
      
        
        // Do any additional setup after loading the view.
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
            
           
            
        }
    }
    
}
