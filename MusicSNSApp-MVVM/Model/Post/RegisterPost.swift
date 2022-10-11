//
//  RegisterPost.swift
//  MusicSNSApp-MVVM
//
//  Created by 近藤米功 on 2022/10/06.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth

class RegisterPost {
    let db = Firestore.firestore()
    let loadUser = LoadUser()

    // Firestoreに投稿情報を保存
    func setPostToFirestore(selectedMusic: MusicInfo,postComment: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let data = try await loadUser.fetchUserFromFirestore(uid: uid) else { return }
        guard let userName = data["userName"] else { return }
        let document = ["artistName": selectedMusic.artistName,
                        "trackName": selectedMusic.trackName,
                        "artworkUrl": selectedMusic.artworkUrl100,
                        "postComment": postComment,
                        "userName": userName,
                        "likeCount": 0,
                        "uid": uid,
                        "createdAt": Timestamp()] as [String : Any]
        try await Firestore.firestore().collection("Posts").document().setData(document)
    }

    // いいねの更新情報をFirestore
    func updatePostLikeToFirestore(post: Post) async throws {
        guard let docId = post.docId else {
            print("docIDがありません")
            return
        }
        let selectedPostDB = db.collection("Posts").document(docId)

        guard let uid = Auth.auth().currentUser?.uid else {
            print("uidがありません")
            return
        }
        guard let data = try await selectedPostDB.getDocument().data() else {
            print("dataがありません")
            return

        }

        var likeCount = 0

        let post = Post(dic: data)
        
        // LikeFlagがあればその中身をtoggleしていいね数を更新
        if let likeFlag = post.likeFlagDic[uid] {
            print("1")
            if likeFlag == true {
                likeCount = post.likeCount - 1
                try await selectedPostDB.setData(["likeFlagDic": [uid: false]],merge: true)
            }else{
                likeCount = post.likeCount + 1
                try await selectedPostDB.setData(["likeFlagDic": [uid: true]],merge: true)
            }
        }else {
            print("2")
            // LikeFlagがなければlikeFlagをmergeしていいね数を＋1にする
            likeCount = post.likeCount + 1
            try await selectedPostDB.setData(["likeFlagDic": [uid: true]],merge: true)
        }
        // likeCount情報をFirestoreに送信
        try await selectedPostDB.updateData(["likeCount": likeCount])

    }

}
