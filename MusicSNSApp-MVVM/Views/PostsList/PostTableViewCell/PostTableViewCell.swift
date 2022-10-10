//
//  PostTableViewCell.swift
//  MusicSNSApp-MVVM
//
//  Created by 近藤米功 on 2022/09/24.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage

class PostTableViewCell: UITableViewCell {
    // MARK: - UI Parts
    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var postImageView: UIImageView!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var commentButton: UIButton!
    @IBOutlet private weak var trackNameLabel: UILabel!
    @IBOutlet private weak var commentTextView: UITextView!
    @IBOutlet private weak var artistNameLabel: UILabel!

    static let identifier = "PostTableViewCell"
    static let nibName = "PostTableViewCell"

    private lazy var postListViewModel = PostListViewModel(likeButtonTapObservable: likeButton.rx.tap.asObservable())
    private let disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        setupBindings()
    }

    private func setupBindings() {
        // TODO: LikeButton押されたらLikeButtonのImageを変更する

        commentButton.rx.tap.subscribe (onNext: {
            // TODO: コメント画面に遷移
        }).disposed(by: disposeBag)
    }

    func configure(post: Post) {
        userImageView.circle()
        trackNameLabel.text = post.trackName
        artistNameLabel.text = post.artistName
        commentTextView.text = post.postComment
        postImageView.sd_setImage(with: URL(string: post.artworkUrl))
        userNameLabel.text = post.userName
        userImageView.image = UIImage(named: "gohan")
    }
    
}
