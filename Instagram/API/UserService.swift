//
//  UserService.swift
//  Instagram
//
//  Created by milad marandi on 12/27/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

typealias FirestoreCompletion = (Error?) -> Void
struct UserService {
    
    static func fetchUser(completion: @escaping (User) -> Void) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_USER.document(uid).getDocument { snapshot, error in
            guard let data = snapshot?.data() , error == nil else {
                return}
            
            let user = User(data: data)
            
            completion(user)
            
        }
    }
    
    static func fetchAllUsers(compeletion: @escaping ([User]) -> Void) {
        
        COLLECTION_USER.getDocuments { snapShot, error in
            guard let snapshot = snapShot , error == nil else {
                print("unable to fetch All users")
                return
            }
            
            let users = snapshot.documents.map{User(data: $0.data())}
            
            compeletion(users)
        }
    }
    
    
    static func follow(uid:String , completion: @escaping (FirestoreCompletion)){
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            return
        }
        
        COLLECTION_FOLLOWING.document(currentUserId).collection("user-following").document(uid).setData([:]) { error in
            
            
            COLLECTION_FOLLOWERS.document(uid).collection("user-followers").document(currentUserId).setData([:], completion: completion)
        }
    }
    
    
    static func unfollow(uid:String , completion: @escaping (FirestoreCompletion)){
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            return
        }
        COLLECTION_FOLLOWING.document(currentUserId).collection("user-following").document(uid).delete { error in
            COLLECTION_FOLLOWERS.document(uid).collection("user-followers").document(currentUserId).delete(completion: completion)
        }
    }
    
    static func checkIfUserIsFollowed(uid:String , completion: @escaping (Bool) -> Void) {
        
        guard let currentId = Auth.auth().currentUser?.uid else {
            return
        }
        
        COLLECTION_FOLLOWING.document(currentId).collection("user-following").document(uid).getDocument { snapshot, error in
            guard let isFollowed = snapshot?.exists else {
                return
            }
            completion(isFollowed)
        }
    }
    
    static func fetchUserStats(uid:String , compeltion: @escaping (UserStats) -> Void) {
        COLLECTION_FOLLOWERS.document(uid).collection("user-followers").getDocuments { snapshot , error in
            guard let snapshot = snapshot ,error == nil else{
                print("error")
                return
            }
            let followers = snapshot.documents.count

            COLLECTION_FOLLOWING.document(uid).collection("user-following").getDocuments { snapshot, error in
                guard let snapshot = snapshot, error == nil else{
                    print("error")
                    return
                }
                let following = snapshot.documents.count
                print(UserStats(followers: followers, following: following))
                compeltion(UserStats(followers: followers, following: following))
            }
        }
    }

}

