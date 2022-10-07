//
//  PostListViewModel.swift
//  MusicSNSApp-MVVM
//
//  Created by 近藤米功 on 2022/10/07.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

// MARK: - Inputs（おそらくcellから受け取る）
protocol PostListViewModelInputs {

}

// MARK: - Outputs
protocol PostListViewModelOutputs {
    var fetchPostPublishSubject: PublishSubject<[Post]> { get }
}

class PostListViewModel: PostListViewModelOutputs {

    // MARK: - Outputs
    var fetchPostPublishSubject =  RxSwift.PublishSubject<[Post]>()

    // MARK: - Model Connect
    let loadPost = LoadPost()

    init(){
        setupBindings()
    }

    private func setupBindings() {
        loadPost.fetchPostsFromFirestore { posts, error in
            if let error = error {
                self.fetchPostPublishSubject.onError(error)
                return
            }
            guard let posts = posts else { return }
            self.fetchPostPublishSubject.onNext(posts)
        }
    }

}
