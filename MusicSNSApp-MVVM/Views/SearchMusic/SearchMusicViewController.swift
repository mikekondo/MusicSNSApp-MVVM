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

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "SearchMusic"
    }
}
