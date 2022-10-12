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

    private let postListViewModel = PostListViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupTableView()
        navigationItem.title = "PostList"
    }

    private func setupTableView() {
        tableView.rowHeight = 550
        tableView.register(UINib(nibName: PostTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: PostTableViewCell.identifier)
    }

    private func setupBindings() {
        postListViewModel.outputs.fetchPostPublishSubject.bind(to: tableView.rx.items(dataSource: PostTableViewDataSource()))
            .disposed(by: disposeBag)
    }
}
