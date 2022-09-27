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

}
