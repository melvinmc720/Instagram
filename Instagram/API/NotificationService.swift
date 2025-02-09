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
        toUid uid: String ,
        fromUser:User,
        type: NotificationType ,
        post:post? = nil)
    {
        
        guard let currentUId = Auth.auth().currentUser?.uid else { return}
        guard  uid != currentUId else { return }
        
        let document = COLLECTION_NOTIFICATIONS
            .document(uid)
            .collection("user-notifications").document()
        
        // uid: who sent the notification
        var data:[String :Any] = [
            "timestamp":Timestamp(date: Date()),
            "uid":fromUser.id,
            "type":type.rawValue,
            "id":document.documentID,
            "userProfileImageUrl":fromUser.profileimage,
            "username":fromUser.username
        ]
        
        if let post = post {
            data["postId"] = post.postID
            data["postImageUrl"] = post.imageURL
        }
        
        document.setData(data)
        
    }
    
    static func fetchNotification(completion: @escaping ([Notification]) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else { return}
        COLLECTION_NOTIFICATIONS.document(uid).collection("user-notifications").getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else {return}
            let notification = documents.map({Notification(dictionary: $0.data())})
            completion(notification)
             
            
        }
    }
}
