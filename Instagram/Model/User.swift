//
//  User.swift
//  Instagram
//
//  Created by milad marandi on 12/27/24.
//

import Foundation
import FirebaseAuth

struct User{
    var Email:String
    var Password:String
    var fullname:String
    var id:String
    var profileimage:String
    var username:String
    
    var iscurrentUser:Bool {
        return Auth.auth().currentUser?.uid == self.id
    }
    
    var isFollowed:Bool = false
    var stats:UserStats
    
    init(data:[String:Any]) {
        self.Email = data["email"] as? String ?? ""
        self.Password = data["Password"] as? String ?? ""
        self.fullname = data["fullname"] as? String ?? ""
        self.id = data["id"] as? String ?? ""
        self.profileimage = data["profileimage"] as? String ?? ""
        self.username = data["username"] as? String ?? ""
        self.stats  = UserStats(followers: 0 , following: 0)
    }
}


struct UserStats{
    let followers:Int
    let following:Int
}
