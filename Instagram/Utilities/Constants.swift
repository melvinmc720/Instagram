//
//  Constants.swift
//  Instagram
//
//  Created by milad marandi on 12/27/24.
//

import Foundation
import FirebaseFirestore

public let COLLECTION_USER = Firestore.firestore().collection("Users")
public let COLLECTION_FOLLOWERS = Firestore.firestore().collection("followers")
public let COLLECTION_FOLLOWING = Firestore.firestore().collection("following")
