//
//  AuthenticationViewModel.swift
//  Instagram
//
//  Created by milad marandi on 12/4/24.
//

import UIKit


protocol FormUpdateView:UIViewController{
    func updateView()
}

// MARK: AuthenticationProtocol
protocol AuthenticationProtocol{
    var EmailAddressText:String? { get set}
    var PasswordText:String? {get set}
    var isFormValid:Bool {get}
}

// MARK: LogInViewModel
struct LogInViewModel:AuthenticationProtocol {
    var EmailAddressText: String?

    var PasswordText: String?

    var isFormValid: Bool{
        guard let emailText = EmailAddressText , let PasswordText = PasswordText else {
            return false
        }
        return !emailText.isEmpty && !PasswordText.isEmpty
    }

    
}

// MARK: RegisterationViewModel

struct RegisterationViewModel:AuthenticationProtocol{
    
    var EmailAddressText:String?
    var PasswordText:String?
    var UsernameText:String?
    var FullNameText:String?
    
    var isFormValid: Bool {
        guard let emailText = EmailAddressText , let PasswordText = PasswordText , let UsernameText = UsernameText , let FullNameText = FullNameText else {
            return false
        }
        return !emailText.isEmpty && !PasswordText.isEmpty && !UsernameText.isEmpty && !FullNameText.isEmpty
    }
}
