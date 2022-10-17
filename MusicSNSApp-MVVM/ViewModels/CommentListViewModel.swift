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
    var selectedTag: Int

    // MARK: - Outputs
    var postCommentPublishSubject = PublishSubject<postResult>()

    private var comment = ""
    private var disposeBag = DisposeBag()

    init(commentTextFieldObservable: Observable<String>,sendButtonObservable: Observable<Void>,selectedTag: Int) {
        self.commentTextFieldObservable = commentTextFieldObservable
        self.sendButtonObservable = sendButtonObservable
        self.selectedTag = selectedTag
        setupBindings()
    }


    private func setupBindings() {
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
        }).disposed(by: disposeBag)
    }
}

// MARK: - CommentListViewModelType
extension CommentListViewModel: CommentListViewModelType {
    var inputs: CommentListViewModelInputs { return self }

    var outputs: CommentListViewModelOutputs { return self }
}
