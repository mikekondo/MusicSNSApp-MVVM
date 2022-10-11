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
    var tagNumber: Int?

    // MARK: - Outputs
    var fetchPostPublishSubject =  RxSwift.PublishSubject<[Post]>()
    var likeFlagBehaviorRelay = RxRelay.BehaviorRelay<Bool>(value: false)

    // MARK: - Model Connect
    private let loadPost = LoadPost()

    private let disposeBag = DisposeBag()

    private var likeFlag = false

    // MARK: PostsListViewController用のInitializer
    init(){
        setupBindings()
    }

    // MARK: PostTableViewCell用のInitializer
    init(likeButtonTapObservable: Observable<Void>) {
        self.likeButtonTapObservable = likeButtonTapObservable
        setupBindings()
    }

    private func setupBindings() {
        likeButtonTapObservable?.subscribe(onNext: {
            guard let tagNumber = self.tagNumber else { return }
            print("tagNumber",tagNumber)
            self.likeFlag.toggle()
            self.likeFlagBehaviorRelay.accept(self.likeFlag)
            // TODO: Firestoreといいね機能の連携
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
