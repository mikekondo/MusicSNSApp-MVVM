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

    @IBOutlet private weak var userNameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var registerButton: UIButton!

    // MARK: - ViewModel Connect
    private lazy var loginViewModel = LoginViewModel(userNameTextFieldObservable: userNameTextField.rx.text.map { $0 ?? ""},
                                                     emailTextFieldObservable: emailTextField.rx.text.map { $0 ?? ""},
                                                     passwordTextFieldObservable: passwordTextField.rx.text.map { $0 ?? ""},
                                                     registerButtonObservable: registerButton.rx.tap.asObservable())

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        loginViewModel.setupBindings()
    }

}
