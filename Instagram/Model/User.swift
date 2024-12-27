//
//  User.swift
//  Instagram
//
//  Created by milad marandi on 12/27/24.
//

import Foundation


struct User{
    var Email:String
    var Password:String
    var fullname:String
    var id:String
    var profileimage:String
    var username:String
    
    init(data:[String:Any]) {
        self.Email = data["email"] as? String ?? ""
        self.Password = data["Password"] as? String ?? ""
        self.fullname = data["fullname"] as? String ?? ""
        self.id = data["id"] as? String ?? ""
        self.profileimage = data["profileimage"] as? String ?? ""
        self.username = data["username"] as? String ?? ""
    }
}
