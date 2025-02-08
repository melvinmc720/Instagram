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
    
    static func ispostLiked(post:post , completion: @escaping (Bool) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_POSTS.document(post.postID).collection("post-likes").document(currentUserId).getDocument { snapshot, error in
            
            guard let didLiked = snapshot?.exists , error == nil else { return}
            completion(didLiked)
        }
    }
    
    static func didLikePost(post:post , completion: @escaping (FirestoreCompletion) ){
        
        guard let currentUserId = Auth.auth().currentUser?.uid else { return}
        
        COLLECTION_POSTS.document(post.postID).updateData(["likes":post.likes + 1])
        
        COLLECTION_POSTS.document(post.postID).collection("post-likes").document(currentUserId).setData([:]) { error in
            
            guard error == nil else { return }
            
            COLLECTION_USER.document(currentUserId).collection("user-likes").document(post.postID).setData([:], completion: completion)
        }
        
    }
    
    static func didUnlikPost(post:post , completion: @escaping (FirestoreCompletion) ){
        guard let currentUserId = Auth.auth().currentUser?.uid else { return}
//        guard post.likes > 0 else { return}
        
        COLLECTION_POSTS.document(post.postID).updateData(["likes":post.likes - 1])
        
        COLLECTION_POSTS.document(post.postID).collection("post-likes").document(currentUserId).delete { _ in
            
            COLLECTION_USER.document(currentUserId).collection("user-likes").document(post.postID).delete(completion: completion)
            
        }
    }
}
