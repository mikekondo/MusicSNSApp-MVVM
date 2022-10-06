//
//  MusicTableViewCell.swift
//  MusicSNSApp-MVVM
//
//  Created by 近藤米功 on 2022/09/24.
//

import UIKit
import SDWebImage

class MusicTableViewCell: UITableViewCell {

    @IBOutlet private weak var artWorkImageView: UIImageView!
    @IBOutlet private weak var trackNameLabel: UILabel!
    @IBOutlet private weak var artistNameLabel: UILabel!

    static var identifier = "MusicCell"
    static var nibName = "MusicTableViewCell"


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(musicInfo: MusicInfo) {
        var musicInfo = musicInfo
        trackNameLabel.text = musicInfo.trackName
        artistNameLabel.text = musicInfo.artistName
        if let range = musicInfo.artworkUrl100.range(of: "100x100bb") {
            musicInfo.artworkUrl100.replaceSubrange(range, with: "2000x2000bb")
        }
        artWorkImageView.sd_setImage(with: URL(string: musicInfo.artworkUrl100))
    }
    
}
