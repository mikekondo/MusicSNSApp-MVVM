//
//  LoadUser.swift
//  MusicSNSApp-MVVM
//
//  Created by 近藤米功 on 2022/10/07.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

class LoadUser {
    let db = Firestore.firestore()
    func fetchUserFromFirestore(uid: String) async throws -> [String: Any]?{
        try await db.collection("Users").document(uid).getDocument().data()
    }
}
