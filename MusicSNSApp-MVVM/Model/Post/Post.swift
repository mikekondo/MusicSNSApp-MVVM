//
//  Post.swift
//  MusicSNSApp-MVVM
//
//  Created by 近藤米功 on 2022/10/06.
//

import Foundation
import Firebase

struct Post {
    let artistName: String
    let artworkUrl: String
    let trackName: String
    let postComment: String
    let createdAt: Timestamp
    let uid: String
    let likeCount: Int
    let userName: String
    init(dic: [String: Any]) {
        self.artistName = dic["artistName"] as? String ?? ""
        self.trackName = dic["trackName"] as? String ?? ""
        self.postComment = dic["postComment"] as? String ?? ""
        self.artworkUrl = dic["artworkUrl"] as? String ?? ""
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
        self.uid = dic["uid"] as? String ?? ""
        self.userName = dic["userName"] as? String ?? ""
        self.likeCount = dic["likeCount"] as? Int ?? Int()
    }
}
