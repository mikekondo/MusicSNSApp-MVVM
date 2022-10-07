//
//  SearchMusicViewController.swift
//  MusicSNSApp-MVVM
//
//  Created by 近藤米功 on 2022/09/20.
//

import UIKit
import RxSwift
import RxCocoa

class SearchMusicViewController: UIViewController {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!

    private lazy var searchMusicViewModel = SearchMusicViewModel(searchBarObservable: searchBar.rx.text.map{ $0 ?? ""}.asObservable())

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "SearchMusic"
        setupTableView()
        setupBindings()
    }

    private func setupTableView() {
        tableView.rowHeight = 70
        tableView.register(UINib(nibName: MusicTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: MusicTableViewCell.identifier)

        // セルの選択時にPostMusicViewControllerに遷移
        tableView.rx.itemSelected.subscribe (onNext: { [weak self] indexPath in
            guard let selectedMusic = self?.searchMusicViewModel.fetchSelectedMusic(index: indexPath.row) else { return }
            let postMusicViewController = PostMusicViewController()
            postMusicViewController.selectedMusic = selectedMusic
            self?.navigationController?.pushViewController(postMusicViewController, animated: true)
        }).disposed(by: disposeBag)
    }


    private func setupBindings() {
        searchMusicViewModel.fetchMusicPublishSubject
            .bind(to: tableView.rx.items(dataSource: SearchMusicTableViewDataSource()))
            .disposed(by: disposeBag)
    }
}
