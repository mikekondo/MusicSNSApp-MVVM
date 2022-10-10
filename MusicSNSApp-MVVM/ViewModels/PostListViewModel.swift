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
    var likeButtonTapObservable: Observable<Void>? { get }
}

// MARK: - Outputs
protocol PostListViewModelOutputs {
    var fetchPostPublishSubject: PublishSubject<[Post]> { get }
}

// MARK: - Type
protocol PostListViewModelType {
    var inputs: PostListViewModelInputs { get }
    var outputs: PostListViewModelOutputs { get }
}

class PostListViewModel: PostListViewModelOutputs, PostListViewModelInputs {
    // MARK: - Inputs
    var likeButtonTapObservable: RxSwift.Observable<Void>?

    // MARK: - Outputs
    var fetchPostPublishSubject =  RxSwift.PublishSubject<[Post]>()

    // MARK: - Model Connect
    private let loadPost = LoadPost()

    private let disposeBag = DisposeBag()

    init(){
        setupBindings()
    }

    init(likeButtonTapObservable: Observable<Void>) {
        self.likeButtonTapObservable = likeButtonTapObservable
    }

    private func setupBindings() {
        likeButtonTapObservable?.subscribe(onNext: {
            print("likeButtonTap")
        }).disposed(by: disposeBag)

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

// MARK: - PostListViewModelType
extension PostListViewModel: PostListViewModelType {
    var inputs: PostListViewModelInputs { return self }

    var outputs: PostListViewModelOutputs { return self }
}
