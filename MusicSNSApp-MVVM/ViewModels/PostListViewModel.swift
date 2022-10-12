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

// MARK: - Inputs（initが複数あるので?をつけている）
protocol PostListViewModelInputs {
    var likeButtonTapObservable: Observable<Void>? { get }
    var commentButtonTapObservable: Observable<Void>? { get }
    var tagNumber: Int? { get }
}

// MARK: - Outputs
protocol PostListViewModelOutputs {
    var fetchPostPublishSubject: PublishSubject<[Post]> { get }
    var likeFlagBehaviorRelay: BehaviorRelay<Bool> { get }
}

// MARK: - Type
protocol PostListViewModelType {
    var inputs: PostListViewModelInputs { get }
    var outputs: PostListViewModelOutputs { get }
}

class PostListViewModel: PostListViewModelOutputs, PostListViewModelInputs {

    // MARK: - Inputs
    var likeButtonTapObservable: RxSwift.Observable<Void>?
    var commentButtonTapObservable: RxSwift.Observable<Void>?
    var tagNumber: Int?

    // MARK: - Outputs
    var fetchPostPublishSubject =  RxSwift.PublishSubject<[Post]>()
    var likeFlagBehaviorRelay = RxRelay.BehaviorRelay<Bool>(value: false)

    // MARK: - Model Connect
    private let registerPost = RegisterPost()
    private let loadPost = LoadPost()

    private let disposeBag = DisposeBag()

    // TODO: 起動時に最新データを反映させる
    private var likeFlag = false

    private var posts = [Post]()

    // MARK: PostsListViewController用のInitializer
    init(){
        setupBindings()
    }

    // MARK: PostTableViewCell用のInitializer
    init(likeButtonTapObservable: Observable<Void>,commentButtonTapObservable: Observable<Void>) {
        self.likeButtonTapObservable = likeButtonTapObservable
        self.commentButtonTapObservable = commentButtonTapObservable
        setupBindings2()
    }

    private func setupBindings() {
        loadPost.fetchPostsFromFirestore { posts, error in
            if let error = error {
                self.fetchPostPublishSubject.onError(error)
                return
            }
            guard let posts = posts else { return }
            self.posts = posts
            self.fetchPostPublishSubject.onNext(posts)
        }
    }

    private func setupBindings2() {
        likeButtonTapObservable?.subscribe(onNext: {
            guard let tagNumber = self.tagNumber else { return }
            self.likeFlag.toggle()
            self.likeFlagBehaviorRelay.accept(self.likeFlag)
            // Firestoreといいね機能の連携
            Task{
                do{
                    try await self.registerPost.updatePostLikeToFirestore(post: self.posts[tagNumber])
                    print("いいねに成功しました")
                }
                catch{
                    print("いいねに失敗しました",error)
                }
            }
        }).disposed(by: disposeBag)

        commentButtonTapObservable?.subscribe(onNext: {
        }).disposed(by: disposeBag)
    }
}

// MARK: - PostListViewModelType
extension PostListViewModel: PostListViewModelType {
    var inputs: PostListViewModelInputs { return self }

    var outputs: PostListViewModelOutputs { return self }
}
