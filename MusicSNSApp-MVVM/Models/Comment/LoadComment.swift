//
//  LoadComment.swift
//  MusicSNSApp-MVVM
//
//  Created by 近藤米功 on 2022/10/18.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth

class LoadComment {
    let db = Firestore.firestore()

    func fetchCommentsFromFirestore(docId: String, completion: @escaping([Comment]?,Error?) -> Void) {
        db.collection("Posts").document(docId).collection("Comment").order(by: "createdAt", descending: true).addSnapshotListener { snapShots, error in
            if let error = error {
                completion(nil,error)
            }
            var comments = [Comment]()
            guard let snapShots = snapShots else { return }
            snapShots.documents.forEach({ snapShot in
                let data = snapShot.data()
                var comment = Comment(dic: data)
                comment.docId = snapShot.documentID
                comments.append(comment)
            })
            completion(comments,nil)
        }
    }
}
