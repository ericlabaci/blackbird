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

class HomeViewModel : BaseViewModel {
    var blackBird : Variable<[BlackBird]> = Variable([])

    override init() {
        super.init()

        self.getAllBlackBirds()
    }
    
    private func getAllBlackBirds() {
        let listener = FirebaseUtils.getAllBlackBirds { (blackBirdArray) in
            self.blackBird.value = blackBirdArray
        }
        if let listener = listener {
            self.addListener(listener: listener)
        }
    }
}
