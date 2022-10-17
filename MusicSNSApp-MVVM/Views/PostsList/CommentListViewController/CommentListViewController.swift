//
//  CommentListViewController.swift
//  MusicSNSApp-MVVM
//
//  Created by 近藤米功 on 2022/10/12.
//

import UIKit

class CommentListViewController: UIViewController {

    var tag = Int() // PostsのドキュメントIDにアクセスするためのtag
    var selectedPost: Post?

    // MARK: - UI Parts
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var commentTextField: UITextField!
    @IBOutlet private weak var sendButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
