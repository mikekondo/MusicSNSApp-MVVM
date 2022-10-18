//
//  CommentTableViewDataSource.swift
//  MusicSNSApp-MVVM
//
//  Created by 近藤米功 on 2022/10/18.
//

import UIKit
import RxSwift
import RxCocoa

final class CommentTableViewDataSource: NSObject, UITableViewDataSource, RxTableViewDataSourceType {

    typealias Element = [Comment]
    var comments: [Comment] = []

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier,for: indexPath) as? CommentTableViewCell else { fatalError("The dequeued cell is not instance")}
        cell.configure(comment: comments[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, observedEvent: RxSwift.Event<[Comment]>) {
        Binder(self){ dataSource, element in
            dataSource.comments = element
            tableView.reloadData()
        }
        .on(observedEvent)
    }

    
}
