//
//  ChallengesCell.swift
//  Fitness Challenge
//
//  Created by Travis Whitten on 12/29/16.
//  Copyright © 2016 Travis Whitten. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseStorageUI

class ChallengesCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var daysLeft: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var numberJoined: UILabel!
    
    var time = 0
    var originalTime = 0
    var stampTime = 0
    var timeDifference = 0
    var progressTime = 0
   
    var timer = Timer()
    var date = Date()
    var calendar = Calendar.current
    
    
    
    
    
    var key = "fart"
    
    var challenges = [Challenge]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(challenge: Challenge) {
        
        let newDate = Date()
        let timeInt = newDate.timeIntervalSince1970
        let myInt = Int(timeInt)
        
        
        title.text = challenge.title
        time = Int(challenge.challengeTime)!
        time = time * 86400
        originalTime = Int(challenge.challengeTime)!
        stampTime = challenge.stampTime
        key = challenge.challengeKey
        //minute = Int(challenge.challengeTime)!
        //Configuring the logo
        let stringURL = NSURL(string: challenge.logoLink)
        logoImg.sd_setImage(with: stringURL as URL?)
        
        timeDifference = (stampTime/1000) + time
        progressTime = timeDifference - myInt
        
        //Getting days between dates
        let date1 = calendar.startOfDay(for: date)
        let date2 = calendar.startOfDay(for: (Date(timeIntervalSinceNow: TimeInterval(progressTime))))
        
        let dayComponenet = calendar.dateComponents([.day], from: date1, to: date2)
        
        
        daysLeft.text = String(describing: (dayComponenet.day)!)
        timeLbl.text = "Days Left"
        
        if(progressTime <= 86400 && progressTime >= 3600) {
             let hourComponenet = calendar.dateComponents([.hour], from: date1, to: date2)
            daysLeft.text = String(describing: (hourComponenet.hour)!)
            timeLbl.text = "Hours Left"
            
        } else if (progressTime < 3600 && progressTime >= 60) {
            let minuteComponenet = calendar.dateComponents([.minute], from: date1, to: date2)
            daysLeft.text = String(describing: (minuteComponenet.minute)!)
            timeLbl.text = "Minutes Left"
    } else if (progressTime < 60 && progressTime >= 0) {
            let secondComponenet = calendar.dateComponents([.second], from: date1, to: date2)
            daysLeft.text = String(describing: (secondComponenet.second)!)
            timeLbl.text = "Seconds Left"
    
    }
        
        DataService.ds.REF_CHALLENGES.child(key).child("joinedChallenger").observe(.value, with: { (snap) in
            
            //print(snap.childrenCount)
            self.numberJoined.text = ("\(snap.childrenCount)")
            DataService.ds.REF_CHALLENGES.child(self.key).updateChildValues(["usersJoined": snap.childrenCount])
            
            
        })
        

        //print("Time Left of Event: ")
        //print("\(Date(timeIntervalSinceNow: TimeInterval(progressTime)))")
        
        
        /*
        print("\(date)")
        
        print("\(progressTime)")
        print("\(time)")
        print("\(myInt/1000)")
        if(progressTime >= 0) {
        progressView.setProgress((((Float(time) - Float(progressTime))/(Float(time))) * 100) , animated: true)
        }
     */
       // runTimer()
        
        
    }
}
