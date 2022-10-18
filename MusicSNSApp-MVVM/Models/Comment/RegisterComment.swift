//
//  RegisterComment.swift
//  MusicSNSApp-MVVM
//
//  Created by 近藤米功 on 2022/10/17.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth

class RegisterComment {
    let db = Firestore.firestore()
    let loadUser = LoadUser()

    func setCommentToFirestore(docId: String,comment: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let data = try await loadUser.fetchUserFromFirestore(uid: uid) else { return }
        guard let userName = data["userName"] else { return }
        let document = ["userName": userName,"createdAt": Timestamp(),"comment": comment]
        try await db.collection("Posts").document(docId).collection("Comment").document().setData(document)
    }
}
