//
//  ProfileCard.swift
//  Blackbird
//
//  Created by Raphael Carletti on 2/26/18.
//  Copyright © 2018 Blackbird. All rights reserved.
//

import UIKit

class ProfileCard: UIView {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var numberFollowing: UILabel!
    @IBOutlet weak var numberFollowers: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var blackBirdsLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }
    
    private func setUpView() {
        let view = viewFromNibForClass()
        view.frame = bounds
        self.userNameLabel.textColor = UIColor.lightGray
        self.followersLabel.textColor = UIColor.lightGray
        self.followingLabel.textColor = UIColor.lightGray
        self.editProfileButton.setTitle("Edit Profile", for: .normal)
        self.editProfileButton.setTitleColor(Color.secondaryColor, for: .normal)
        self.editProfileButton.layer.borderWidth = 2
        self.editProfileButton.layer.borderColor = Color.secondaryColor.cgColor
        self.editProfileButton.layer.cornerRadius = 10
        self.editProfileButton.clipsToBounds = true
        self.profileImage.clipsToBounds = true
        self.profileImage.layer.cornerRadius = self.profileImage.frame.width/2
        self.blackBirdsLabel.textColor = UIColor.lightGray
        self.separatorView.backgroundColor = UIColor.lightGray
        
        
        addSubview(view)
    }
    
    
    private func viewFromNibForClass() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return view
    }
    
}
