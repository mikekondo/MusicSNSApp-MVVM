//
//  MyPostCollectionViewDataSource.swift
//  MusicSNSApp-MVVM
//
//  Created by 近藤米功 on 2022/10/10.
//

import UIKit
import RxSwift
import RxCocoa

final class MyPostCollectionViewDataSource: NSObject, UICollectionViewDataSource, RxCollectionViewDataSourceType {

    typealias Element = [Post]
    var myPostArray: [Post] = []

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myPostArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyPostCollectionViewCell.identifier, for: indexPath) as? MyPostCollectionViewCell else {
            fatalError("The dequeued cell is not instance")
        }
        // TODO: Configure書く
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, observedEvent: RxSwift.Event<[Post]>) {
        Binder(self) { datasource, element in
            datasource.myPostArray = element
            collectionView.reloadData()
        }
        .on(observedEvent)
    }


}
