//
//  MessagesTVC.swift
//  Fitness Challenge
//
//  Created by Travis Whitten on 6/22/17.
//  Copyright © 2017 Travis Whitten. All rights reserved.
//

import UIKit
import FirebaseStorageUI

class MessagesTVC: UITableViewCell {
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var lastMessageLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(messages: Messages) {
        lastMessageLbl.text = messages.text
        
        let stringURL = NSURL(string: messages.photoURL)
        profileImg.sd_setImage(with: stringURL as URL?)

        
    }

}
