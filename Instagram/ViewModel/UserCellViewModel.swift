//
//  SearchVM.swift
//  Instagram
//
//  Created by milad marandi on 12/30/24.
//

import Foundation
import UIKit


struct UserCellViewModel{
    
    var profileImage:String {
        return user?.profileimage ?? ""
    }
    var username:String {
        return user?.username ?? ""
    }
    var fullName:String{
        return user?.fullname ?? ""
    }
    
    var user:User?
    
    init(user:User?){
        self.user = user
    }
    
}
