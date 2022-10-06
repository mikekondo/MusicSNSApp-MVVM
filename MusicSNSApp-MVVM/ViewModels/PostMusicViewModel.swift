//
//  PostMusicViewModel.swift
//  MusicSNSApp-MVVM
//
//  Created by 近藤米功 on 2022/10/06.
//

import Foundation
import RxSwift
import RxCocoa

enum TestError: Error{
    case any
}

// MARK: - Inputs
protocol PostMusicViewModelInput {
    var commentTextViewObservable: Observable<String> { get }
    var postButtonTapObservable: Observable<Void> { get }
}

// MARK: - Outputs
protocol PostMusicViewModelOutput {
    var isPostSuccess: PublishSubject<Void> { get }
}

class PostMusicViewModel: PostMusicViewModelInput,PostMusicViewModelOutput{
    // MARK: Inputs
    var commentTextViewObservable: RxSwift.Observable<String>
    var postButtonTapObservable: RxSwift.Observable<Void>

    // MARK: Outputs
    var isPostSuccess = RxSwift.PublishSubject<Void>()

    private let disposeBag = DisposeBag()

    private var comment = ""

    init(commentTextViewObservable: Observable<String>,postButtonTapObservable: Observable<Void>){
        self.commentTextViewObservable = commentTextViewObservable
        self.postButtonTapObservable = postButtonTapObservable
        setupBindings()
    }

    private func setupBindings() {
        commentTextViewObservable.subscribe { comment in
            self.comment = comment
        }.disposed(by: disposeBag)

        postButtonTapObservable.subscribe (onNext: { [weak self] in
            // self?.isPostSuccess.onCompleted()
            self?.isPostSuccess.onError(TestError.any)
            print("tap")
        }).disposed(by: disposeBag)
    }

}
