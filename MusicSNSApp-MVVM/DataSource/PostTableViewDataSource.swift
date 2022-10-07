//
//  PostTableViewDataSource.swift
//  MusicSNSApp-MVVM
//
//  Created by 近藤米功 on 2022/10/07.
//

import RxSwift
import RxCocoa
import SDWebImage
import UIKit

final class PostTableViewDataSource: NSObject, UITableViewDataSource, RxTableViewDataSourceType {
    
    typealias Element = [Post]
    var posts: [Post] = []

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier,for: indexPath) as? PostTableViewCell else { fatalError("The dequeued cell is not instance")}

        // TODO: ユーザ名を取得、写真を取得
        cell.configure(post: posts[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, observedEvent: Event<[Post]>) {
        Binder(self){ dataSource, element in
            dataSource.posts = element
            tableView.reloadData()
        }
        .on(observedEvent)
    }
    
}
