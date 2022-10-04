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

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

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
    }

    private func setupBindings() {
        searchMusicViewModel.fetchMusicPublishSubject
            .bind(to: tableView.rx.items(dataSource: SearchMusicTableViewDataSource()))
            .disposed(by: disposeBag)
    }
}