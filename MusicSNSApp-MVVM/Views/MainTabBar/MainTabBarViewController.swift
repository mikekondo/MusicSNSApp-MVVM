//
//  ViewController.swift
//  MusicSNSApp-MVVM
//
//  Created by 近藤米功 on 2022/09/20.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initTabBar()
    }

    private func initTabBar() {
        let profileVC = ProfileViewController()
        profileVC.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 0)
        let profileNVC = UINavigationController(rootViewController: profileVC)

        let postListVC = PostListViewController()
        postListVC.tabBarItem = UITabBarItem(tabBarSystemItem: .recents, tag: 1)
        let postListNVC = UINavigationController(rootViewController: postListVC)

        let searchMusicVC = SearchMusicViewController()
        searchMusicVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 2)
        let searchMusicNVC = UINavigationController(rootViewController: searchMusicVC)

        setViewControllers([postListNVC,searchMusicNVC,profileNVC], animated: false)

    }

}
