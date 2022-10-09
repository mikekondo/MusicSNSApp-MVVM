//
//  SearchMusicViewModel.swift
//  MusicSNSApp-MVVM
//
//  Created by 近藤米功 on 2022/09/28.
//

import RxSwift
import RxCocoa
import Foundation

// MARK: - Inputs
protocol SearchMusicViewModelInputs {
    var searchBarObservable: Observable<String> { get }
}

// MARK: - Outputs
protocol SearchMusicViewModelOutputs {
    var fetchMusicPublishSubject: PublishSubject<[MusicInfo]> { get }
}

// MARK: - Type
protocol SearchMusicViewModelType {
    var inputs: SearchMusicViewModelInputs { get }
    var outputs: SearchMusicViewModelOutputs { get }
}

class SearchMusicViewModel: SearchMusicViewModelInputs, SearchMusicViewModelOutputs{
    // MARK: Input
    var searchBarObservable: Observable<String>

    // MARK: Output
    var fetchMusicPublishSubject = PublishSubject<[MusicInfo]>()

    // MARK: Model Connect
    private var music = Music()

    private (set) var musicInfos: [MusicInfo] = []

    let disposeBag = DisposeBag()

    init(searchBarObservable: Observable<String>) {
        self.searchBarObservable = searchBarObservable

        setupBindings()
    }

    private func setupBindings() {
        searchBarObservable.subscribe(onNext: { text in
            guard let url = URL(string: "https://itunes.apple.com/search?term=\(text)&entity=song&contry=jp") else { return }
            Task{
                do{
                    self.musicInfos = try await self.music.fetchMusicData(url: url)
                    self.fetchMusicPublishSubject.onNext(self.musicInfos)
                }
                catch{
                    print("楽曲情報の取得に失敗",error)
                    self.fetchMusicPublishSubject.onError(error)
                }
            }
        }).disposed(by: disposeBag)
    }

    func fetchSelectedMusic(index: Int) -> MusicInfo {
        if let range = musicInfos[index].artworkUrl100.range(of: "100x100bb"){
            musicInfos[index].artworkUrl100.replaceSubrange(range, with: "2000x2000bb")
        }
        return musicInfos[index]
    }
}

// MARK: - SearchMusicViewModelType
extension SearchMusicViewModel: SearchMusicViewModelType {
    var inputs: SearchMusicViewModelInputs { return self }

    var outputs: SearchMusicViewModelOutputs { return self }
}
