//
//  PostMusicViewModel.swift
//  MusicSNSApp-MVVM
//
//  Created by 近藤米功 on 2022/10/06.
//

import Foundation
import RxSwift
import RxCocoa

enum postResult: Error {
    case success
    case failure
    case empty
}

// MARK: - Inputs
protocol PostMusicViewModelInput {
    var commentTextViewObservable: Observable<String> { get }
    var postButtonTapObservable: Observable<Void> { get }
}

// MARK: - Outputs
protocol PostMusicViewModelOutput {
    var postMusicPublishSubject: PublishSubject<postResult> { get }
}

// MARK: - Type
protocol PostMusicViewModelType {
    var inputs: PostMusicViewModelInput { get }
    var outputs: PostMusicViewModelOutput { get }
}

class PostMusicViewModel: PostMusicViewModelInput,PostMusicViewModelOutput{
    // MARK: - Inputs
    var commentTextViewObservable: RxSwift.Observable<String>
    var postButtonTapObservable: RxSwift.Observable<Void>

    // MARK: - Outputs
    var postMusicPublishSubject = RxSwift.PublishSubject<postResult>()

    // MARK: - Model Connect
    let registerPost = RegisterPost()

    var selectedMusic: MusicInfo?

    private let disposeBag = DisposeBag()

    private var postComment = ""

    init(commentTextViewObservable: Observable<String>,postButtonTapObservable: Observable<Void>){
        self.commentTextViewObservable = commentTextViewObservable
        self.postButtonTapObservable = postButtonTapObservable
        setupBindings()
    }

    private func setupBindings() {
        commentTextViewObservable.subscribe { postComment in
            self.postComment = postComment
        }.disposed(by: disposeBag)

        postButtonTapObservable.subscribe (onNext: {
            guard let selectedMusic = self.selectedMusic else { return }
            // コメントが空ならエラー送信
            if self.postComment.isEmpty == true {
                self.postMusicPublishSubject.onNext(postResult.empty)
                return
            }
            Task{
                do{
                    try await self.registerPost.setPostToFirestore(selectedMusic: selectedMusic, postComment: self.postComment)
                    self.postMusicPublishSubject.onNext(postResult.success)
                }
                catch{
                    self.postMusicPublishSubject.onNext(postResult.failure)
                }
            }
        }).disposed(by: disposeBag)
    }
}

// MARK: - PostMusicViewModelType
extension PostMusicViewModel: PostMusicViewModelType {
    var inputs: PostMusicViewModelInput { return self }

    var outputs: PostMusicViewModelOutput { return self }
}
