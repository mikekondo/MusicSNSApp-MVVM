//
//  MyPostCollectionViewCell.swift
//  MusicSNSApp-MVVM
//
//  Created by 近藤米功 on 2022/10/10.
//

import UIKit

class MyPostCollectionViewCell: UICollectionViewCell {

    static let identifier = "MyPostCollectionViewCell"
    static let nibName = "MyPostCollectionViewCell"

    @IBOutlet weak var trackNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
