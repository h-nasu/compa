//
//  FriendTableViewCell.swift
//  Compa
//
//  Created by MacBook Pro on 5/9/2560 BE.
//  Copyright © 2560 CyberWorks. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var friendImage: UIImageView!
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var friendBirthday: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        friendImage.round()
    }

}



