//
//  ProfileViewController.swift
//  MusicSNSApp-MVVM
//
//  Created by 近藤米功 on 2022/09/20.
//

import UIKit
import RxCocoa
import RxSwift

class ProfileViewController: UIViewController {

    // MARK: - UI Parts
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!

    // MARK: - View Model Connect
    private let profileViewModel = ProfileViewModel()

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Profile"
        setupView()
        setupBindings()
        setupCollectionView()
    }

    // MARK: - Functions
    private func setupView() {
        profileImageView.circle()
        profileImageView.image = UIImage(named: "gohan")
        // TODO: 投稿数、フォロー数、フォロワー数の表示
    }
    private func setupBindings() {
        let dataSource = MyPostCollectionViewDataSource()
        profileViewModel.fetchMyPostPublishSubject.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.register(UINib(nibName: MyPostCollectionViewCell.nibName, bundle: nil), forCellWithReuseIdentifier: MyPostCollectionViewCell.identifier)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    // MARK: セルのレイアウト調整（3列)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = collectionView.bounds.width
            let cellWidth = (width - 30) / 3 // compute your cell width
            return CGSize(width: cellWidth, height: cellWidth / 0.6)
    }
}
