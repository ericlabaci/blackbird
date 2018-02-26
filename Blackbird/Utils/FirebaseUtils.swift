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
        Firestore.firestore().collection(FirebaseKnots.UserNames.Root).document(FirebaseKnots.UserNames.UserNames.Root).setData([FirebaseKnots.UserNames.UserNames.UserNames : [userName : true]], options: SetOptions.merge()) { (error) in
            if let error = error {
                failure?(error)
            } else {
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
    }
    
    //MARK: - Home
    static func addBlackBird(data: [String: Any], success: (() -> ())?, failure: ((Error)-> ())?) {
        if let user = Auth.auth().currentUser {
            let uidVar = UUIDUtils.uuidBasedOnTime()
            ConsoleLogger.log("Started to send a blackbird to firestore")
            Firestore.firestore().collection(FirebaseKnots.Blackbirds.Root).document(user.uid).setData([uidVar : data], options: SetOptions.merge(), completion: { (error) in
                if let error = error {
                    ConsoleLogger.log("Started to send a blackbird to firestore with error: \(error.localizedDescription)")
                    failure?(error)
                } else {
                    ConsoleLogger.log("Ended to send a blackbird to firestore without error")
                    success?()
                }
            })
        }
    }
    
    static func getAllBlackBirds(success: @escaping ([BlackBird]) -> ()) -> ListenerRegistration? {
        if let user = Auth.auth().currentUser {
            return Firestore.firestore().collection(FirebaseKnots.Blackbirds.Root).document(user.uid).addSnapshotListener { (snapshot, error) in
                guard let snap = snapshot, let data = snap.data() else{
                    return
                }
                FirebaseUtils.getUser(success: { (userBB) in
                    var blackBirdsArray : [BlackBird] = []
                    for value in data.values {
                        if let valueDict = value as? [String: Any] {
                            let blackBird = BlackBird(data: valueDict, userId: user.uid)
                            blackBird.user = userBB
                            blackBirdsArray.append(blackBird)
                        }
                    }
                    blackBirdsArray = blackBirdsArray.sorted(by: { (blackBird1, blackBird2) -> Bool in
                        if blackBird1.time.compare(blackBird2.time) == ComparisonResult.orderedDescending {
                            return true
                        } else {
                            return false
                        }
                    })
                    success(blackBirdsArray)
                })
            }
        }
        return nil
    }
    
    static func getUser(success: @escaping (UserBlackBird) -> ()) {
        if let user = Auth.auth().currentUser {
            Firestore.firestore().collection(FirebaseKnots.Users.Root).document(user.uid).getDocument(completion: { (snapshot, error) in
                guard let snap = snapshot, let data = snap.data(), let name = data[FirebaseKnots.Users.Name] as? String, let userName = data[FirebaseKnots.Users.UserName] as? String else {
                    return
                }
                let user = UserBlackBird(name: name, userName: userName)
                success(user)
            })
        }
    }
    
    static func filteredFunc() {
        let user = Auth.auth().currentUser
        
        Firestore.firestore().collection(FirebaseKnots.Blackbirds.Root)
    }
}
