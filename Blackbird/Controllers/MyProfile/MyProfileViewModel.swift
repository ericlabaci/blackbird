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

class MyProfileViewModel {
    var blackBird : Variable<[BlackBird]> = Variable([])
    
    init() {
        self.getAllBlackBirds()
    }
    
    func getAllBlackBirds() {
        FirebaseUtils.getAllBlackBirds { (blackBirdArray) in
            self.blackBird.value = blackBirdArray
        }
    }
    
}
