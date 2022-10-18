//
//  Comment.swift
//  MusicSNSApp-MVVM
//
//  Created by 近藤米功 on 2022/10/17.
//

import Foundation
import Firebase

struct Comment {
    let userName: String
    let comment: String
    let createdAt: Timestamp

    var docId: String?

    init(dic: [String: Any]) {
        self.userName = dic["userName"] as? String ?? ""
        self.comment = dic["comment"] as? String ?? ""
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
    }
}
