//
//  PostMusicViewController.swift
//  MusicSNSApp-MVVM
//
//  Created by 近藤米功 on 2022/10/06.
//

import UIKit
import RxSwift
import RxCocoa
import PKHUD
import SDWebImage

class PostMusicViewController: UIViewController {
    // MARK: - UI Parts
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var postButton: UIButton!

    // MARK: - Model Connect
    var selectedMusic: MusicInfo?

    private let disposeBag = DisposeBag()

    private lazy var postViewModel = PostMusicViewModel(commentTextViewObservable: commentTextView.rx.text.map{$0 ?? ""}.asObservable(), postButtonTapObservable: postButton.rx.tap.asObservable())


    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBindings()
    }

    private func setupView() {
        guard let selectedMusic = selectedMusic else { return }
        artworkImageView.sd_setImage(with: URL(string: selectedMusic.artworkUrl100))
        trackNameLabel.text = selectedMusic.trackName
        artistNameLabel.text = selectedMusic.artistName
    }

    private func setupBindings() {
        postViewModel.isPostSuccess.subscribe (onError: { error in
            HUD.flash(.labeledError(title: "失敗", subtitle: "コメントを入力してください?"),delay: 1)
            print(error)
        }, onCompleted: { [weak self] in
            HUD.flash(.labeledSuccess(title: "成功", subtitle: "投稿されました"),delay: 1)
        }).disposed(by: disposeBag)
    }

}
