//
//  FirebaseUtils.swift
//  Blackbird
//
//  Created by Eric Labaci on 2/22/18.
//  Copyright © 2018 Blackbird. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

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
    
    
    static func register(email: String, password: String, name: String, userName: String, profileImage: UIImage?, success: ((User) -> ())?, failure: ((Error)-> ())?) {
        Database.database().reference().child("\(FirebaseKnots.UserNames.Root)/\(userName)").setValue("") { (error, databaseReference) in
            if let error = error {
                failure?(error)
            } else {
                Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                    if let error = error {
                        failure?(error)
                    } else if let user = user {
                        Database.database().reference().child("\(FirebaseKnots.UserNames.Root)/\(userName)").setValue(user.uid)
                        Database.database().reference().child("\(FirebaseKnots.Users.Root)/\(user.uid)").setValue([FirebaseKnots.Users.Name : name, FirebaseKnots.Users.UserName : userName, FirebaseKnots.Users.Followers : [], FirebaseKnots.Users.Following : []], withCompletionBlock: { (error, databaseReference) in
                            if let error = error {
                                failure?(error)
                            } else if let profileImage = profileImage {
                                if let resizedImage = self.resize(image: profileImage, toWidth: 128), let imageData = UIImagePNGRepresentation(resizedImage) {
                                    Storage.storage().reference().child("profileImages/\(user.uid)").putData(imageData, metadata: nil, completion: { (storageMetadata, error) in
                                        if let error = error {
                                            failure?(error)
                                        } else {
                                            success?(user)
                                        }
                                    })
                                } else {
                                    success?(user)
                                }
                            } else {
                                success?(user)
                            }
                        })
                    }
                }
            }
        }
    }
    
    static func resize(image: UIImage?, toWidth width: CGFloat) -> UIImage? {
        guard let image = image else {
            return nil
        }
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/image.size.width * image.size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, image.scale)
        defer { UIGraphicsEndImageContext() }
        image.draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    //MARK: - Home
    static func addBlackBird(data: [String: Any], success: (() -> ())?, failure: ((Error)-> ())?) {
        if let user = Auth.auth().currentUser {
            ConsoleLogger.log("Started to send a blackbird to firestore")
            let reference = Database.database().reference().child(FirebaseKnots.Blackbirds.Root).child(user.uid).childByAutoId()
            reference.setValue(data, withCompletionBlock: { (error, dbreference) in
                if let error = error {
                    failure?(error)
                } else {
                    addBlackBirdToFollowing(uuid: reference.key, success: success)
                }
            })
        }
    }
    
    static private func addBlackBirdToFollowing(uuid: String, success: (() -> ())?) {
        if let user = Auth.auth().currentUser {
            Database.database().reference().child(FirebaseKnots.FollowingBlackbirds.Root).child(user.uid).child(uuid).setValue(user.uid, withCompletionBlock: { (error, dbref) in
                //FIXME: - Adjust how to handle error
                if error != nil {
                    ConsoleLogger.log("Error adding to following")
                } else {
                    success?()
                }
            })
        }
    }
    
    static func getAllBlackBirdsFromSinglePerson(userId: String, success: @escaping ([BlackBird]) -> ()) -> UInt {
        let listener = Database.database().reference().child(FirebaseKnots.Blackbirds.Root).child(userId).observe(.childAdded) { (snapshot) in
            FirebaseUtils.getUser(userId: userId, success: { (userBB) in
                var blackBirdsArray : [BlackBird] = []
                if let dict = snapshot.value as? [String : Any] {
                    let blackBird = BlackBird(data: dict, userId: userId)
                    blackBird.user = userBB
                    blackBirdsArray.append(blackBird)
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
        return listener
    }

    static func getUser(userId: String,success: @escaping (UserBlackBird) -> ()) {
        Database.database().reference().child(FirebaseKnots.Users.Root).child(userId).observeSingleEvent(of: .value) { (snapshot) in
            guard let user = Auth.auth().currentUser, let data = snapshot.value as? NSDictionary, let name = data[FirebaseKnots.Users.Name] as? String, let userName = data[FirebaseKnots.Users.UserName] as? String else {
                return
            }
            Storage.storage().reference().child("profileImages/\(user.uid)").getData(maxSize: INT64_MAX, completion: { (data, error) in
                if let data = data {
                    let user = UserBlackBird(name: name, userName: userName, profileImage: UIImage(data: data))
                    success(user)
                } else {
                    let user = UserBlackBird(name: name, userName: userName)
                    success(user)
                }
            })
        }
    }
    
//    static func getAllBlackBirdsFollowing(success: @escaping ([BlackBird]) -> ()) -> ListenerRegistration? {
//        if let user = Auth.auth().currentUser {
//            let listener =  Firestore.firestore().collection(FirebaseKnots.FollowingBlackbirds.Root).document(user.uid).addSnapshotListener { (snapshot, error) in
//                guard let snap = snapshot, let data = snap.data() else{
//                    return
//                }
//                for (key, value) in data {
//                    FirebaseUtils.getBlackBirdWithUUID(uuid: key)
////                    FirebaseUtils.getUser(userId: value as? String, success: { (userBB) in
////                        let blackBird = BlackBird(data: valueDict, userId: user.uid)
////                        blackBird.user = userBB
////                        //                        blackBirdsArray.append(blackBird)
////                    })
//                }
//            }
//            return listener
//        }
//        return nil
//    }
//    
//    
//    static func getBlackBirdWithUUID(uuid: String) {
//        if let user = Auth.auth().currentUser {
//            Firestore.firestore().collection(FirebaseKnots.Blackbirds.Root).whereField(FieldPath([uuid]) , isEqualTo: uuid).getDocuments(completion: { (snapshot, error) in
//                guard let snap = snapshot else {
//                    ConsoleLogger.log("ERROR GETTING SPECIFIC BLACK BIRD")
//                    return
//                }
//                for document in snap.documents {
//                    print(document)
//                    
//                }
//            })
//        }
//    }
}
