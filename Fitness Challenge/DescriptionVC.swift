//
//  DescriptionVC.swift
//  Fitness Challenge
//
//  Created by Travis Whitten on 12/29/16.
//  Copyright © 2016 Travis Whitten. All rights reserved.
//

import UIKit

class DescriptionVC: UIViewController {

    @IBOutlet weak var viaSegueLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    
    @IBAction func joinBtnPresses(_ sender: Any) {
        
        performSegue(withIdentifier: "joinChallenge", sender: self)
        
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
