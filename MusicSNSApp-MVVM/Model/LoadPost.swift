//
//  LoadPost.swift
//  MusicSNSApp-MVVM
//
//  Created by 近藤米功 on 2022/10/07.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth

class LoadPost {
    let db = Firestore.firestore()

    func fetchPostsFromFirestore() async throws -> [String: Any]?{
        try await db.collection("Posts").document().getDocument().data()
    }
}
