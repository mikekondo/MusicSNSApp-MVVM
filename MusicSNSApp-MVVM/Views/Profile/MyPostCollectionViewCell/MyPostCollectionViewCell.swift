//
//  MyPostCollectionViewCell.swift
//  MusicSNSApp-MVVM
//
//  Created by 近藤米功 on 2022/10/10.
//

import UIKit
import SDWebImage

class MyPostCollectionViewCell: UICollectionViewCell {
    // MARK: - UI Parts
    @IBOutlet weak var artworkImageView: UIImageView!

    static let identifier = "MyPostCollectionViewCell"
    static let nibName = "MyPostCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(post: Post) {
        artworkImageView.sd_setImage(with: URL(string: post.artworkUrl))
    }
}
