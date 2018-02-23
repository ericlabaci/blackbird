//
//  SettingsViewController.swift
//  Blackbird
//
//  Created by Raphael Carletti on 2/23/18.
//  Copyright © 2018 Blackbird. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseAuth

class SettingsViewController : BaseViewController {
    @IBOutlet weak var logOutButton: UIButton! {
        didSet {
            self.logOutButton.backgroundColor = Color.secondaryColor
            self.logOutButton.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupLogOutButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupLogOutButton() {
        self.logOutButton.rx.controlEvent(UIControlEvents.touchUpInside).subscribe(onNext: {
            do {
                try Auth.auth().signOut()
                NavigationUtils.goToLogin()
            } catch {
                ConsoleLogger.log("Error when signing out from Firebase Auth")
            }
            
        }).disposed(by: self.disposeBag)
    }
}
