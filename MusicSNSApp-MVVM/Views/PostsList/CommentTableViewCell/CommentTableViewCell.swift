//
//  CommentTableViewCell.swift
//  MusicSNSApp-MVVM
//
//  Created by 近藤米功 on 2022/10/18.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    // MARK: - UI Parts
    @IBOutlet weak var commentLabel: UILabel!

    static let nibName = "CommentTableViewCell"
    static let identifier = "CommentTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(comment: Comment) {
        commentLabel.text = comment.comment
    }
    
}
