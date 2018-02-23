//
//  HomeViewModel.swift
//  Blackbird
//
//  Created by Raphael Carletti on 2/22/18.
//  Copyright © 2018 Blackbird. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import FirebaseFirestore

class HomeViewModel {
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
