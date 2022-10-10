//
//  Music.swift
//  MusicSNSApp-MVVM
//
//  Created by 近藤米功 on 2022/09/27.
//

import Foundation

struct MusicInfos: Codable {
    let results: [MusicInfo]
}

struct MusicInfo: Codable {
    let artistName: String
    let trackName: String
    var artworkUrl100: String
    let releaseDate: String
}

class Music {
    // .resultsでreturnしたいので[MusicInfo]にしている
    func fetchMusicData(url: URL) async throws -> [MusicInfo] {
        let request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        let musicInfos = try JSONDecoder().decode(MusicInfos.self, from: data)
        return musicInfos.results
    }
}
