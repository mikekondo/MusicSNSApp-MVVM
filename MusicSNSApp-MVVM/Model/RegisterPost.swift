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
                        "uid": uid,"createdAt": Timestamp()] as [String : Any]
        try await Firestore.firestore().collection("Posts").document().setData(document)
    }

}
