//
//  MyProfileViewModel.swift
//  Blackbird
//
//  Created by Raphael Carletti on 2/26/18.
//  Copyright © 2018 Blackbird. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import FirebaseAuth

class MyProfileViewModel : BaseViewModel {
    var blackBird : Variable<[BlackBird]> = Variable([])
    
    override init() {
        super.init()
        
        self.getAllBlackBirds()
    }
    
    func getAllBlackBirds() {
        if let user = Auth.auth().currentUser {
            let listener = FirebaseUtils.getAllBlackBirdsFromSinglePerson(userId: user.uid, success: { (blackBirdArray) in
                self.blackBird.value = blackBirdArray
            })
            
            if let listener = listener {
                self.addListener(listener: listener)
            }
        }
    }
    
}
