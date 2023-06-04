    //
    //  CommentViewController.swift
    //  We are friend
    //
    //  Created by おのしょうき on 2022/12/18.
    //

    import Foundation
    import FirebaseFirestore

    struct Comment {
       
        let content: String
        let commentID: String
        let postID: String
        let createdAt: Timestamp
        
        init(data: [String: Any]) {
            content = data["content"] as! String
            commentID = data["commentID"] as! String
            postID = data["postID"] as! String
            createdAt = data["createdAt"] as? Timestamp ?? Timestamp()
        }
    }
