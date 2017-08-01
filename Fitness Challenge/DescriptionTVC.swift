//
//  DescriptionTVC.swift
//  Fitness Challenge
//
//  Created by Travis Whitten on 7/26/17.
//  Copyright © 2017 Travis Whitten. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorageUI

class DescriptionTVC: UITableViewController {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var logoImg: UIImageView!
    
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var descriptionText: UILabel!
    
    @IBOutlet weak var rulesLbl: UILabel!
    @IBOutlet weak var rulesText: UILabel!

    @IBOutlet weak var prizesText: UILabel!
    
    @IBAction func unwindToDescriptionTVC(segue: UIStoryboardSegue) {}
    
    var date = Date()
    var newTotalTime = 0
    var newCurrentTime = 0
    
    var challengeTitle = ""
    var challengeDescription = ""
    var challengeRules = ""
    var challengePrizes = ""
    var challengeKey = ""
    var challengeLogo = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLbl.text = challengeTitle
        descriptionText.text = challengeDescription
        rulesText.text = challengeRules
        prizesText.text = challengePrizes
        print("CHALLENGE SELECTED: \(challengeKey)")
        
        //Setting Logo Image
        let stringURL = NSURL(string: challengeLogo)
        logoImg.sd_setImage(with: stringURL as URL?)
        
        //Navigation Bar Title
        navigationItem.title = "Challenge"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editTapped))
        self.navigationItem.rightBarButtonItem!.tintColor = UIColor.init(red: 0.40, green: 0.85, blue: 1.0, alpha: 1.0)
        
        
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

    @IBAction func leaderboardBtnPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "goToLeaderboards", sender: self)
        
    }
   
    @IBAction func joinBtnPressed(_ sender: Any) {
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            var navigationBar = navigationController?.navigationBar
            
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
            
        } else if segue.identifier == "editTheChallenge" {
            let destination2 = segue.destination as! EditChallengeTVC
            
            
            
            let challengeKey = self.challengeKey
            
            
            destination2.challengeKey = challengeKey
            
        }
    }
    
    
    
    func editTapped() {
        
        performSegue(withIdentifier: "editTheChallenge", sender: self)
        
    }

    

}
