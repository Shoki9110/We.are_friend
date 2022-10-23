//
//  UserViewController.swift
//  We are friend
//
//  Created by おのしょうき on 2022/08/07.
//

import Foundation
import Firebase

struct AppUser {
    let userID: String
    let userName: String
    
    init(data: [String: Any]) {
        userID = data["userID"] as! String
        userName = data["userName"] as! String
    }
}
