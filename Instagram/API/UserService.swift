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
                print("your error is \(error?.localizedDescription)")
                return}
            
            let user = User(data: data)
            
            completion(user)
            
        }
    }

}

