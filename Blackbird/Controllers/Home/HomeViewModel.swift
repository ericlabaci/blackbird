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

class HomeViewModel {
    var tweets : Variable<[Tweet]> = Variable([])
    
    init() {
        tweets.value = [Tweet(name: "Raphael", user: "@raphacarletti", tweet: "Nossa, hoje ta tao legal"), Tweet(name: "Eric", user: "@ericlabaci", tweet: "RX e mt dificil rsrsrsrs")]
    }
}
