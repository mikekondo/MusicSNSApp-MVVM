//
//  PostTableViewCell.swift
//  MusicSNSApp-MVVM
//
//  Created by 近藤米功 on 2022/09/24.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseAuth
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
    @IBOutlet private weak var likeCountLabel: UILabel!

    static let identifier = "PostTableViewCell"
    static let nibName = "PostTableViewCell"

    let heartFill = UIImage(systemName: "heart.fill")
    let heart = UIImage(systemName: "heart")

    private lazy var postListViewModel = PostListViewModel(likeButtonTapObservable: likeButton.rx.tap.asObservable(), commentButtonTapObservable: commentButton.rx.tap.asObservable())
    private let disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        setupBindings()
    }

    // MARK: - setupBindings
    private func setupBindings() {
        // likeButtonのタグをViewModelのtag
        likeButton.rx.tap.subscribe (onNext: {
            self.postListViewModel.tagNumber = self.likeButton.tag
        }).disposed(by: disposeBag)

        // LikeButton押されたらLikeButtonのImageを変更する
        postListViewModel.outputs.likeFlagBehaviorRelay.subscribe(onNext: { likeFlag in
            if likeFlag == true {
                self.likeButton.setImage(self.heartFill, for: .normal)
            }else{
                self.likeButton.setImage(self.heart, for: .normal)
            }
        })
    }

    func configure(post: Post,index: Int) {
        userImageView.circle()
        trackNameLabel.text = post.trackName
        artistNameLabel.text = post.artistName
        commentTextView.text = post.postComment
        postImageView.sd_setImage(with: URL(string: post.artworkUrl))
        userNameLabel.text = post.userName
        likeButton.tag = index
        commentButton.tag = index
        userImageView.image = UIImage(named: "gohan")
        likeCountLabel.text = "\(post.likeCount)いいね"

        guard let uid = Auth.auth().currentUser?.uid else { return }
        if let likeFlag = post.likeFlagDic[uid]{
            if likeFlag == true {
                likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            }else{
                likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            }
        }else{
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
}
