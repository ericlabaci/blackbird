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

class MyProfileViewModel : BaseViewModel {
    var blackBird : Variable<[BlackBird]> = Variable([])
    
    override init() {
        super.init()
        
        self.getAllBlackBirds()
    }
    
    func getAllBlackBirds() {
        let listener = FirebaseUtils.getAllBlackBirds { (blackBirdArray) in
            self.blackBird.value = blackBirdArray
        }
        
        if let listener = listener {
            self.addListener(listener: listener)
        }
    }
    
}
