//
//  RegisterUser.swift
//  MusicSNSApp-MVVM
//
//  Created by 近藤米功 on 2022/09/25.
//

import Firebase
import FirebaseFirestore
import FirebaseAuth

class RegisterUser {

    let db = Firestore.firestore()

    func registerUserToFirestore (userName: String,email: String, password: String) async throws {
        // アカウント作成
        try await Auth.auth().createUser(withEmail: email, password: password)
        // FirestoreにUserを登録
        try await setUserToFirestore(userName: userName,email: email, password: password)
    }

    private func setUserToFirestore(userName: String,email: String, password: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let docData = ["userName": userName,"email": email,"createdAt": Timestamp()] as [String : Any]
        try await db.collection("Users").document(uid).setData(docData)
    }
}
