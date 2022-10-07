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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(post: Post) {
        trackNameLabel.text = post.trackName
        artistNameLabel.text = post.artistName
        commentTextView.text = post.comment
        postImageView.sd_setImage(with: URL(string: post.artworkUrl))
    }
    
}
