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
import FirebaseAuth

class HomeViewModel : BaseViewModel {
    var blackBird : Variable<[BlackBird]> = Variable([])

    override init() {
        super.init()

        self.getAllBlackBirds()
    }
    
    private func getAllBlackBirds() {
//        let listener = FirebaseUtils.getAllBlackBirdsFollowing { (blackBirds) in
//            self.blackBird.value = blackBirds
//        }
//            
//            if let listener = listener {
//                self.addListener(listener: listener)
//            }
//        }
}
