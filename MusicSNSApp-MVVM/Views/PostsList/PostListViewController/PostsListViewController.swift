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
    // MARK: - UI Parts
    @IBOutlet weak var tableView: UITableView!

    // MARK: - View Model Connect
    private lazy var postListViewModel = PostListViewModel()

    private var selectedPost: Post?

    private let disposeBag = DisposeBag()

    var postTableViewDataSource = PostTableViewDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupTableView()
        setupNotificationCenter()
        navigationItem.title = "PostList"
    }

    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(didTapCommentButton), name: .getTag, object: nil)
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
    }

    // コメントボタンをタップすると画面遷移
    @objc private func didTapCommentButton(notification: Notification) {
        guard let tag = notification.userInfo?["tag"] as? Int else { return }
        // commentListViewControllerへ画面遷移
        let commentListViewController = CommentListViewController()
        commentListViewController.tag = tag
        self.navigationController?.pushViewController(commentListViewController, animated: true)
    }
}
