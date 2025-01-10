//
//  AuthService.swift
//  Instagram
//
//  Created by milad marandi on 12/14/24.
//

import FirebaseAuth
import FirebaseStorage
import UIKit
import FirebaseFirestore

struct singupFormModel{
    var email:String
    var password:String
    var username:String
    var fullName:String
    var image:UIImage
}

struct signInModel{
    var email:String
    var password:String
}


final class AuthService {
    
    
    static func signout(completion:@escaping (Error?) -> Void){
        do {
            try Auth.auth().signOut()
            completion(nil)
        }
        
        catch let error {
            completion(error)
        }
    }
    
    
    static func Signup(
        with credential: singupFormModel, completion: @escaping () -> Void
    ) {
        AuthService.uploadImage(image: credential.image) { urlPath in
            Auth
                .auth()
                .createUser(
                    withEmail: credential.email,
                    password: credential.password) { result, error in
                        
                        guard let id = result?.user.uid ,error == nil else {
                            return
                        }
                        
                        let userData:[String : Any] = [
                            "Email":credential.email,
                            "Password":credential.password,
                            "id":id,
                            "profileimage":urlPath,
                            "username":credential.username,
                            "fullname":credential.fullName
                        ]
                        
                        let Database = Firestore.firestore()
                        let collection  = Database.collection("Users")
                        collection.document(id).setData(userData) { error in
                            guard error == nil else {
                                print("unable to save data in firestore")
                                return
                            }
                            
                            print("successfully added")
                            
                            completion()
                        }
                        
                        
                    }
        }
        
    }
    
    static func SignIn(with credential: signInModel,
        completion: @escaping
        () -> Void) {
        Auth
            .auth()
            .signIn(
                withEmail: credential.email,
                password: credential.password
            ) { _, error in
            
            guard error == nil else {
                fatalError("unable to signIn")
            }
            
            print("successfully signin")
            completion()
        }
    }
    
    static  func uploadImage(
        image:UIImage ,
        completion: @escaping (String) -> Void
    ) {
        
        guard let imageJPEG = image.jpegData(compressionQuality: 0.75) else {
            return
        }
        let id = NSUUID().uuidString
        let storage = Storage.storage().reference(withPath: "/profile_Images/\(id)")
        storage.putData(imageJPEG , metadata: nil) { _, error in
            guard error == nil else {
                print("you have an error here")
                return
            }
            
            storage.downloadURL { url, error in
                guard let urlPath = url?.absoluteString , error == nil else {
                    print("error in uploading image")
                    return
                }
                
                completion(urlPath)
                
            }
        }
    }
    
}
