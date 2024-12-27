//
//  profileHeaderViewModel.swift
//  Instagram
//
//  Created by milad marandi on 12/27/24.
//

import Foundation


struct profileHeaderViewModel{
    
    var user:User
    var username:String?{
        return self.user.fullname
    }
    var profileImageURL:URL? {
        return URL(string: self.user.profileimage)
    }
    
    init(user:User){
        self.user = user
    }
    
}
