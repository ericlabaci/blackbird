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

class HomeViewModel : BaseViewModel {
    var blackBird : Variable<[BlackBird]> = Variable([])
    
    private var getAllBlackBirdsListener: UInt = 0

    override init() {
        super.init()

        self.getAllBlackBirds()
    }
    
    private func getAllBlackBirds() {
//        self.getAllBlackBirdsListener = FirebaseUtils.getAllBlackBirdsFollowing { (blackBirds) in
//            self.blackBird.value = blackBirds
//        }
    }
}
