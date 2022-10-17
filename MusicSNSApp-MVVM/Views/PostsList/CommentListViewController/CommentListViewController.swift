//
//  CommentListViewController.swift
//  MusicSNSApp-MVVM
//
//  Created by 近藤米功 on 2022/10/12.
//

import UIKit
import RxSwift
import RxCocoa
import PKHUD

class CommentListViewController: UIViewController {

    var tag = Int() // PostsのドキュメントIDにアクセスするためのtag
    var selectedPost: Post?

    // MARK: - UI Parts
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var commentTextField: UITextField!
    @IBOutlet private weak var sendButton: UIButton!

    private let disposeBag = DisposeBag()

    // MARK: - ViewModel Connect
    private lazy var commentListViewModel = CommentListViewModel(commentTextFieldObservable: commentTextField.rx.text.map{$0 ?? ""}.asObservable(), sendButtonObservable: sendButton.rx.tap.asObservable(), selectedTag: tag)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }

    private func setupBindings() {
        commentListViewModel.postCommentPublishSubject.subscribe (onNext: { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    HUD.flash(.labeledSuccess(title: "成功", subtitle: "コメントを送信しました"),delay: 1)
                }
            case .failure:
                DispatchQueue.main.async {
                    HUD.flash(.labeledError(title: "失敗", subtitle: "失敗しました"),delay: 1)
                }
            case .empty:
                DispatchQueue.main.async {
                    HUD.flash(.labeledError(title: "失敗", subtitle: "コメントを入力してください"),delay: 1)
                }
            }
        }).disposed(by: disposeBag)
    }

}
