//
//  SearchMusicTableViewDataSource.swift
//  MusicSNSApp-MVVM
//
//  Created by 近藤米功 on 2022/09/27.
//

import RxSwift
import RxCocoa
import SDWebImage
import UIKit

final class SearchMusicTableViewDataSource: NSObject, UITableViewDataSource, RxTableViewDataSourceType {

    typealias Element = [MusicInfo]
    var musicInfos: [MusicInfo] = []

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicInfos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MusicTableViewCell.identifier,for: indexPath) as? MusicTableViewCell else { fatalError("The dequeued cell is not instance")}
        cell.configure(musicInfo: musicInfos[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, observedEvent: Event<[MusicInfo]>) {
        Binder(self){ dataSource, element in
            dataSource.musicInfos = element
            tableView.reloadData()
        }
        .on(observedEvent)
    }
}
