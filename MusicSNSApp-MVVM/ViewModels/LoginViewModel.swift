//
//  LoginViewModel.swift
//  MusicSNSApp-MVVM
//
//  Created by 近藤米功 on 2022/09/25.
//

import RxSwift
import RxRelay

protocol LoginViewModelInputs {
    var userNameTextFieldObservable: Observable<String> { get }
    var emailTextFieldObservable: Observable<String> { get }
    var passwordTextFieldObservable: Observable<String> { get }
    var registerButtonObservable: Observable<Void> { get }
}

protocol LoginViewModelOutputs {
    // アカウント可能のフラグ（userName, email. passwordの文字数指定）
    var isValidRegister: PublishSubject<Bool> { get }
    // アカウント登録成功のフラグ？（成功したら画面遷移）
    var isSuccessCreateUser: PublishSubject<Bool> { get }

}

class LoginViewModel: LoginViewModelInputs, LoginViewModelOutputs{

    // MARK: - Inputs
    var userNameTextFieldObservable: Observable<String>
    var emailTextFieldObservable: Observable<String>
    var passwordTextFieldObservable: Observable<String>
    var registerButtonObservable: Observable<Void>

    // MARK: - Outputs
    var isSuccessCreateUser = PublishSubject<Bool>()
    var isValidRegister = PublishSubject<Bool>()

    private let disposeBag = DisposeBag()

    // MARK: - valid
    private var userNameValid = false
    private var emailValid = false
    private var passwordValid = false


    init(userNameTextFieldObservable: Observable<String>,
         emailTextFieldObservable: Observable<String>,
         passwordTextFieldObservable: Observable<String>,
         registerButtonObservable: Observable<Void>) {
        self.userNameTextFieldObservable = userNameTextFieldObservable
        self.emailTextFieldObservable = emailTextFieldObservable
        self.passwordTextFieldObservable = passwordTextFieldObservable
        self.registerButtonObservable = registerButtonObservable
    }

    func setupBindings() {
        // HACK: ユーザ名の有効、無効判断
        userNameTextFieldObservable.subscribe { text in
            guard let userName = text.element else { return }
            if userName.count > 5 {
                self.userNameValid = true
            }
            print("userNameValid:",self.userNameValid)
        }
        .disposed(by: disposeBag)

        // HACK: メールアドレスの有効、無効判断
        emailTextFieldObservable.subscribe { text in
            guard let email = text.element else { return }
            if email.count > 5 && email.contains("@gmail.com") {
                self.emailValid = true
            }
            print("emailValid:",self.emailValid)
        }
        .disposed(by: disposeBag)

        // HACK: パスワードの有効、無効判断
        passwordTextFieldObservable.subscribe { text in
            guard let password = text.element else { return }
            if password.count > 5 {
                self.passwordValid = true
            }
            print("password",self.passwordValid)
        }
        .disposed(by: disposeBag)
    }
}
