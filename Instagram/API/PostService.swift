//
//  PostService.swift
//  Instagram
//
//  Created by kiana mehdiof on 1/10/25.
//

import UIKit
import FirebaseAuth
import FirebaseCore

struct PostService {
    static func UploadPost(caption:String , image:UIImage ,user:User, completion:@escaping(FirestoreCompletion)){
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        AuthService.uploadImage(image: image) { imageURL in
            let data = ["caption":caption ,
                        "timestamp":Timestamp(date: Date()),
                        "likes":0,
                        "imageURL":imageURL,
                        "ownerID":uid,
                        "ownerImageURL":user.profileimage,
                        "ownerUsername": user.username
            ] as [String:Any]
            COLLECTION_POSTS.addDocument(data: data, completion: completion)
        }
    }
    
    
    static func fetchPosts(completion: @escaping ([post]) -> Void) {
        COLLECTION_POSTS.order(by: "timestamp", descending: true).getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {
                return
            }
            
            let posts = documents.map({post(postID: $0.documentID, dictionary:$0.data())})
            completion(posts)
        }
    }
    
    
    static func fetchPosts(forUser id:String , completion: @escaping ([post]) -> Void) {
        
        let query = COLLECTION_POSTS.whereField("ownerID", isEqualTo: id)
        
        query.getDocuments { snapshot, error in
            guard let documents = snapshot?.documents , error == nil else { return }
            
            var posts = documents.map({ post(postID: $0.documentID, dictionary: $0.data())})
            posts = posts.sorted { post1, post2 in
                return post1.timestamp.seconds > post2.timestamp.seconds
            }
            
            completion(posts)
        }
    }
}
