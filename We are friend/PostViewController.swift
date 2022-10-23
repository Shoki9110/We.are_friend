//
//  PostViewController.swift
//  We are friend
//
//  Created by おのしょうき on 2022/08/07.
//

import Foundation
import Firebase

struct Post {
    
    let content: String
    let postID: String
    let senderID: String
    let createdAt: Timestamp
    let updatedAt: Timestamp

    init(data: [String: Any]) {
        content = data["content"] as! String
        postID = data["postID"] as! String
        senderID = data["senderID"] as! String
        createdAt = data["createdAt"] as! Timestamp
        updatedAt = data["updatedAt"] as! Timestamp
    }
}

