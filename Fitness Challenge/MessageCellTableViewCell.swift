//
//  MessageCellTableViewCell.swift
//  Fitness Challenge
//
//  Created by Travis Whitten on 6/22/17.
//  Copyright © 2017 Travis Whitten. All rights reserved.
//

import UIKit

class MessageCellTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userMessage: UILabel!
    @IBOutlet weak var sentTime: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    


    

}
