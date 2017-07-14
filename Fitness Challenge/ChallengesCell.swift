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
    @IBOutlet weak var dateLbl: UILabel!
   
    
    var time = 0
    var originalTime = 0
    var stampTime = 0
    var timeDifference = 0
    var progressTime = 0
   
    var timer = Timer()
    var date = Date()
    var calendar = Calendar.current
    var challengeKey = ""
    
    
    
    
    
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
        let stampTimeInSeconds = stampTime/1000
        let stampTimeDate = Date(timeIntervalSince1970: TimeInterval(stampTimeInSeconds))
        let month = calendar.component(.month, from: stampTimeDate)
        let day = calendar.component(.day, from: stampTimeDate)
        let year = calendar.component(.year, from: stampTimeDate)
        
        self.dateLbl.text = "\(month)/\(day)/\(year)"
       
        key = challenge.challengeKey
        //minute = Int(challenge.challengeTime)!
        //Configuring the logo
        let stringURL = NSURL(string: challenge.logoLink)
        logoImg.sd_setImage(with: stringURL as URL?)
        
        timeDifference = (stampTime/1000) + time
        progressTime = timeDifference - myInt
        
        //Getting days between dates
        let date1 = self.date
        let date2 = Date(timeIntervalSinceNow: TimeInterval(progressTime))
        //print("Date 1: \(date1)")
        //print("Date 2: \(date2)")
        if (progressTime > 86400) {
        let dayComponent = calendar.dateComponents([.day], from: date1, to: date2)
        
        
        //daysLeft.text = String(describing: (dayComponenet.day)!)
        timeLbl.text = "\(String(describing: (dayComponent.day)!)) Days Left"
        
        } else if(progressTime <= 86400 && progressTime > 3600) {
             let hourComponent = calendar.dateComponents([.hour], from: date1, to: date2)
            //let hourComponent2 = calendar.dateComponents([.hour], from: Date(timeIntervalSprogressTime*1000))
            //daysLeft.text = String(describing: (hourComponenet.hour)!)
            timeLbl.text = "\(String(describing: (hourComponent.hour)!)) Hours Left"
            //print("\(String(describing: (hourComponent.hour)!)) Hours Left")
            
        } else if (progressTime <= 3600 && progressTime > 60) {
            let minuteComponent = calendar.dateComponents([.minute], from: date1, to: date2)
            //daysLeft.text = String(describing: (minuteComponenet.minute)!)
            timeLbl.text = "\(String(describing: (minuteComponent.minute)!)) Minutes Left"
            //print("\(progressTime)")
    } else if (progressTime <= 60 && progressTime > 0) {
            let secondComponent = calendar.dateComponents([.second], from: date1, to: date2)
            //daysLeft.text = String(describing: (secondComponenet.second)!)
            timeLbl.text = "\(String(describing: (secondComponent.second)!)) Seconds Left"
            //print("\(progressTime)")
    
        } else if (progressTime <= 0) {
            timeLbl.text = "Ended"
        }
        
        DataService.ds.REF_CHALLENGES.child(key).child("joinedChallenger").observe(.value, with: { (snap) in
            
            //print(snap.childrenCount)
            self.numberJoined.text = ("\(snap.childrenCount)")
            DataService.ds.REF_CHALLENGES.child(self.key).updateChildValues(["usersJoined": snap.childrenCount])
            
            
        })
      
        
        
    }
    
    //TODO: Allow user to re-edit the challenge or delete it
   
    
    
  
}
