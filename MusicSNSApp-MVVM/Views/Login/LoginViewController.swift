//
//  LoginViewController.swift
//  MusicSNSApp-MVVM
//
//  Created by 近藤米功 on 2022/09/24.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {

    // MARK: - UI Parts
    @IBOutlet private weak var userNameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var registerButton: UIButton!

    // MARK: - ViewModel Connect
    private lazy var loginViewModel = LoginViewModel(userNameTextFieldObservable: userNameTextField.rx.text.map { $0 ?? ""},
                                                     emailTextFieldObservable: emailTextField.rx.text.map { $0 ?? ""},
                                                     passwordTextFieldObservable: passwordTextField.rx.text.map { $0 ?? ""},
                                                     registerButtonTapObservable: registerButton.rx.tap.asObservable())

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: Binding
        loginViewModel.setupBindings()

        // MainTabBarViewControllerに画面遷移
        loginViewModel.isSuccessCreateUser.subscribe(onNext: { [weak self] success in
            let mainTabBar = MainTabBarViewController()
            mainTabBar.modalPresentationStyle = .fullScreen
            self?.present(mainTabBar, animated: true,completion: nil)
        }, onError: { [weak self] error in
            print("アカウント作成に失敗しました",error)
        })
        .disposed(by: disposeBag)
    }

}
