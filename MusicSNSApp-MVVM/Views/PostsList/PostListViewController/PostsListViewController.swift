//
//  PostListViewController.swift
//  MusicSNSApp-MVVM
//
//  Created by 近藤米功 on 2022/09/20.
//

import UIKit
import RxSwift
import RxCocoa

class PostsListViewController: UIViewController {

    @IBOutlet weak var dummyButton: UIButton!
    // MARK: - UI Parts
    @IBOutlet weak var tableView: UITableView!

//    private lazy var postListViewModel = PostListViewModel(dummyButtonTapObservable: dummyButton.rx.tap.asObservable())

    private lazy var postListViewModel = PostListViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupTableView()
        navigationItem.title = "PostList"
    }

    // MARK: - setupTableView
    private func setupTableView() {
        tableView.rowHeight = 550
        tableView.register(UINib(nibName: PostTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: PostTableViewCell.identifier)
    }

    // MARK: - setupBindings
    private func setupBindings() {
        postListViewModel.outputs.fetchPostPublishSubject.bind(to: tableView.rx.items(dataSource: PostTableViewDataSource()))
            .disposed(by: disposeBag)

        postListViewModel.outputs.commentButtonTapPublishSubject.subscribe (onNext: { [weak self] tagNumber in
            print("タグ受け取り",tagNumber)
            let commentListViewController = CommentListViewController()
            self?.navigationController?.pushViewController(commentListViewController, animated: true)
        }).disposed(by: disposeBag)
    }
}
