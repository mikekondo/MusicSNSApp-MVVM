//
//  PostListViewModel.swift
//  MusicSNSApp-MVVM
//
//  Created by 近藤米功 on 2022/10/07.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

// MARK: Inputs（おそらくcellから受け取る）
protocol PostListViewModelInputs {

}

// MARK: Outputs
protocol PostListViewModelOutputs {
    var fetchPostPublishSubject: PublishSubject<[Post]> { get }
}

class PostListViewModel: PostListViewModelOutputs {

    // MARK: Outputs
    var fetchPostPublishSubject =  RxSwift.PublishSubject<[Post]>()


}
