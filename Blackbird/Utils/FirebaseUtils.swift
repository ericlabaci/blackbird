//
//  FirebaseUtils.swift
//  Blackbird
//
//  Created by Eric Labaci on 2/22/18.
//  Copyright © 2018 Blackbird. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class FirebaseUtils {
    //MARK: - Authentication
    static func login(email: String, password: String, success: ((User) -> ())?, failure: ((Error)-> ())?) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                failure?(error)
            } else if let user = user {
                success?(user)
            }
        }
    }
    
    static func register(email: String, password: String, name: String, userName: String, success: ((User) -> ())?, failure: ((Error)-> ())?) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                failure?(error)
            } else if let user = user {
                Firestore.firestore().collection(FirebaseKnots.Users.Root).document(user.uid).setData([FirebaseKnots.Users.Name : name, FirebaseKnots.Users.UserName : userName, FirebaseKnots.Users.Followers : [], FirebaseKnots.Users.Following : []]) { error in
                    if let error = error {
                        failure?(error)
                    } else {
                        success?(user)
                    }
                }
            }
        }
    }
}
