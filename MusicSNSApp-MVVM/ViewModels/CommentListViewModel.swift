//
//  CommentListViewModel.swift
//  MusicSNSApp-MVVM
//
//  Created by 近藤米功 on 2022/10/17.
//

import Foundation
import RxSwift
import RxCocoa

protocol CommentListViewModelInputs {
    var commentTextFieldObservable: Observable<String> { get }
    var sendButtonObservable: Observable<Void> { get }
}

protocol CommentListViewModelOutputs {
    var postCommentPublishSubject: PublishSubject<postResult> { get }
    var fetchCommentsPublishSubject: PublishSubject<[Comment]> { get }
}

// MARK: - Type
protocol CommentListViewModelType {
    var inputs: CommentListViewModelInputs { get }
    var outputs: CommentListViewModelOutputs { get }
}

class CommentListViewModel: CommentListViewModelInputs, CommentListViewModelOutputs {
    // MARK: - Inputs
    var commentTextFieldObservable: RxSwift.Observable<String>
    var sendButtonObservable: RxSwift.Observable<Void>
    var docId: String

    // MARK: - Outputs
    var postCommentPublishSubject = PublishSubject<postResult>()
    var fetchCommentsPublishSubject = RxSwift.PublishSubject<[Comment]>()

    private var comment = ""
    private var comments = [Comment]()
    private var loadComment = LoadComment()
    private var disposeBag = DisposeBag()
    let registerComment = RegisterComment()

    init(commentTextFieldObservable: Observable<String>,sendButtonObservable: Observable<Void>,docId: String) {
        self.commentTextFieldObservable = commentTextFieldObservable
        self.sendButtonObservable = sendButtonObservable
        self.docId = docId
        setupBindings()
    }


    private func setupBindings() {
        loadComment.fetchCommentsFromFirestore(docId: self.docId) { comments, error in
            if let error = error {
                print("error",error)
            }
            guard let comments = comments else { return }
            self.comments = comments
            self.fetchCommentsPublishSubject.onNext(comments)
        }

        commentTextFieldObservable.subscribe { comment in
            print("comment",comment)
            self.comment = comment
        }.disposed(by: disposeBag)

        sendButtonObservable.subscribe (onNext: {
            print("送信ボタンタップ")
            // コメントが空ならエラー送信
            if self.comment.isEmpty == true {
                self.postCommentPublishSubject.onNext(postResult.empty)
                return
            }
            // Firestoreにコメントを送信
            Task{
                do{
                    try await self.registerComment.setCommentToFirestore(docId: self.docId, comment: self.comment)
                    self.postCommentPublishSubject.onNext(postResult.success)
                }catch {
                    self.postCommentPublishSubject.onNext(postResult.failure)
                }
            }

        }).disposed(by: disposeBag)
    }
}

// MARK: - CommentListViewModelType
extension CommentListViewModel: CommentListViewModelType {
    var inputs: CommentListViewModelInputs { return self }

    var outputs: CommentListViewModelOutputs { return self }
}
