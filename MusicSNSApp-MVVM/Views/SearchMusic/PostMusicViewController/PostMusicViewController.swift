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
    @IBOutlet private weak var artworkImageView: UIImageView!
    @IBOutlet private weak var trackNameLabel: UILabel!
    @IBOutlet private weak var artistNameLabel: UILabel!
    @IBOutlet private weak var commentTextView: UITextView!
    @IBOutlet private weak var postButton: UIButton!

    var selectedMusic: MusicInfo?

    private let disposeBag = DisposeBag()

    private lazy var postViewModel = PostMusicViewModel(commentTextViewObservable: commentTextView.rx.text.map{$0 ?? ""}.asObservable(), postButtonTapObservable: postButton.rx.tap.asObservable())

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBindings()
        // 選択された楽曲情報をViewModelに渡してあげる
        postViewModel.selectedMusic = selectedMusic
    }

    private func setupView() {
        guard let selectedMusic = selectedMusic else { return }
        artworkImageView.sd_setImage(with: URL(string: selectedMusic.artworkUrl100))
        trackNameLabel.text = selectedMusic.trackName
        artistNameLabel.text = selectedMusic.artistName
    }

    private func setupBindings() {
        postViewModel.outputs.postMusicPublishSubject.subscribe (onNext: { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    HUD.flash(.labeledSuccess(title: "成功", subtitle: "投稿されました"),delay: 1)
                }
            case .failure:
                DispatchQueue.main.async {
                    HUD.flash(.labeledError(title: "失敗", subtitle: "失敗しました"),delay: 1)
                }
            case .empty:
                DispatchQueue.main.async {
                    HUD.flash(.labeledError(title: "失敗", subtitle: "コメントを入力してください"),delay: 1)
                }
            }
        }).disposed(by: disposeBag)


    }

}
