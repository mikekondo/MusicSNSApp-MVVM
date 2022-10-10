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

    // 投稿を投稿順に取得
    func fetchPostsFromFirestore(completion: @escaping([Post]?,Error?) -> Void){
        db.collection("Posts").order(by: "createdAt", descending: true).addSnapshotListener { snapShots, error in
            if let error = error {
                completion(nil,error)
            }
            var posts = [Post]()
            guard let snapShots = snapShots else { return }
            snapShots.documents.forEach({ snapShot in
                let data = snapShot.data()
                let post = Post(dic: data)
                posts.append(post)
            })
            completion(posts,nil)
        }
    }

    // 自分の投稿を投稿順に取得
    func fetchMyPostsFromFirestore(completion: @escaping([Post]?,Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("Posts").order(by: "createdAt", descending: true).whereField("uid", isEqualTo: uid).addSnapshotListener { snapShots, error in
            if let error = error {
                completion(nil,error)
            }
            var posts = [Post]()
            guard let snapShots = snapShots else { return }
            snapShots.documents.forEach ({ snapShot in
                let data = snapShot.data()
                let post = Post(dic: data)
                posts.append(post)
            })
            completion(posts,nil)
        }
    }
}
