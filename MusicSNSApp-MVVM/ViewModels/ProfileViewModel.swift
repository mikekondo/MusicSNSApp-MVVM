//
//  ProfileViewModel.swift
//  MusicSNSApp-MVVM
//
//  Created by 近藤米功 on 2022/10/10.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

// TODO: おそらくCellから受け取る？
// MARK: - Inputs
protocol ProfileViewModelInputs {

}

// MARK: - Outputs
protocol ProfileViewModelOutputs {
    // NOTE: PublishSubjectだとCollectionViewが表示されない
    var fetchMyPostPublishSubject: BehaviorSubject<[Post]> { get }
}

// MARK: - Type
protocol ProfileViewModelType {
    var inputs: ProfileViewModelInputs { get }
    var outputs: ProfileViewModelOutputs { get }
}

class ProfileViewModel: ProfileViewModelInputs,ProfileViewModelOutputs{

    // MARK: - Outputs
    var fetchMyPostPublishSubject = BehaviorSubject<[Post]>(value: [])

    // MARK: - Model Connect
    let loadPost = LoadPost()

    // MARK: - Initializer
    init() {
        setupBindings()
    }

    // MARK: - Functions
    private func setupBindings() {
        loadPost.fetchMyPostsFromFirestore { posts, error in
            if let error = error {
                self.fetchMyPostPublishSubject.onError(error)
                print("error:",error)
                return
            }
            guard let posts = posts else { return }
            self.fetchMyPostPublishSubject.onNext(posts)
        }
    }
}

// MARK: - ProfileViewModelType
extension ProfileViewModel: ProfileViewModelType {
    var inputs: ProfileViewModelInputs { return self }

    var outputs: ProfileViewModelOutputs { return self }
}
