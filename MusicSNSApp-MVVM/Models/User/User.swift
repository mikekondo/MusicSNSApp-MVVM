//
//  User.swift
//  MusicSNSApp-MVVM
//
//  Created by 近藤米功 on 2022/09/25.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct User {
    let createdAt: Timestamp
    let email: String
    let userName: String
    init(dic: [String: Any]) {
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
        self.email = dic["email"] as? String ?? ""
        self.userName = dic["userName"] as? String ?? ""
    }
}
