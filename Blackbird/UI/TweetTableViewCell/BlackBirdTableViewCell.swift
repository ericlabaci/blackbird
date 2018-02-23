//
//  TweetTableViewCell.swift
//  Blackbird
//
//  Created by Raphael Carletti on 2/22/18.
//  Copyright © 2018 Blackbird. All rights reserved.
//

import UIKit

class BlackBirdTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var userLabel: UILabel! {
        didSet {
            self.userLabel.textColor = UIColor.lightGray
        }
    }
    @IBOutlet var blackBirdLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCellWith(blackBird: BlackBird) {
        FirebaseUtils.getUser { (name, userName) in
            self.nameLabel.text = name
            self.blackBirdLabel.text = blackBird.text
            self.userLabel.text = userName
        }
    }
    
}
