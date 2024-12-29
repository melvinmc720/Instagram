//
//  UserService.swift
//  Instagram
//
//  Created by milad marandi on 12/27/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
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

}

