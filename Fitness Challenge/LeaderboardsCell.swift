//
//  LeaderboardsCell.swift
//  Fitness Challenge
//
//  Created by Travis Whitten on 1/2/17.
//  Copyright © 2017 Travis Whitten. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorageUI

class LeaderboardsCell: UITableViewCell {
    @IBOutlet weak var repsLbl: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userProfileImg: UIImageView!
    @IBOutlet weak var rankLbl: UILabel!
    
   
   

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
        
    
    
    func configureCell(leader: Leaderboard) {
        
        userNameLbl.text = leader.userName
        repsLbl.text = leader.reps
       
        let stringURL = NSURL(string: leader.profileImg)
        self.userProfileImg.sd_setImage(with: stringURL as URL?)
        //let videoLink = leader.videoLink
       // userNameLbl.text = userName as! String?
        
        userProfileImg.layer.cornerRadius = userProfileImg.frame.size.height/2
        userProfileImg.contentMode = .scaleAspectFill
        userProfileImg.clipsToBounds = true
        userProfileImg.layer.borderWidth = 3
        userProfileImg.layer.borderColor = UIColor.white.cgColor
    
        
        
        
    }

}
