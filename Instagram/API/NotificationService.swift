//
//  NotificationService.swift
//  Instagram
//
//  Created by milad marandi on 2/7/25.
//

import Firebase
import FirebaseAuth

struct NotificationService{
    
    static func uploadNotification(
        toUid uid:String ,
        type: NotificationType ,
        post:post? = nil)
    {
        
        guard let currentUId = Auth.auth().currentUser?.uid else { return}
        
        var data:[String :Any] = [
            "timestamp":Timestamp(date: Date()),
            "uid":currentUId,
            "type":type.rawValue
        ]
        
        if let post = post {
            data["postId"] = post.postID
            data["postImageUrl"] = post.imageURL
        }
        
        COLLECTION_NOTIFICATIONS
            .document(uid)
            .collection("user-notifications").addDocument(data: data)
        
    }
    
    static func fetchNotification(){
        
    }
}
