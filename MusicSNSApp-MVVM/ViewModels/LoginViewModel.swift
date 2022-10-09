//
//  LoginViewModel.swift
//  MusicSNSApp-MVVM
//
//  Created by 近藤米功 on 2022/09/25.
//

import RxSwift
import RxRelay

// MARK: - Inputs
protocol LoginViewModelInputs {
    var userNameTextFieldObservable: Observable<String> { get }
    var emailTextFieldObservable: Observable<String> { get }
    var passwordTextFieldObservable: Observable<String> { get }
    var registerButtonTapObservable: Observable<Void> { get }
    var profileImageTapButtonObservable: Observable<Void> { get }
}

// MARK: - Outputs
protocol LoginViewModelOutputs {
    // アカウント登録可能のフラグ（userName, email. passwordの文字数指定）
    var isValidRegister: PublishSubject<Bool> { get }
    // アカウント登録成功のフラグ？（成功したら画面遷移）
    var isSuccessCreateUser: PublishSubject<Bool> { get }
}

// MARK: - Type
protocol LoginViewModelType {
    var inputs: LoginViewModelInputs { get }
    var outputs: LoginViewModelOutputs { get }
}

class LoginViewModel: LoginViewModelInputs, LoginViewModelOutputs {

    // MARK: - Inputs
    var userNameTextFieldObservable: Observable<String>
    var emailTextFieldObservable: Observable<String>
    var passwordTextFieldObservable: Observable<String>
    var registerButtonTapObservable: Observable<Void>
    var profileImageTapButtonObservable: Observable<Void>

    // MARK: - Outputs
    var isSuccessCreateUser = PublishSubject<Bool>()
    var isValidRegister = PublishSubject<Bool>()

    // MARK: - Model Connect
    let registerUser = RegisterUser()

    private let disposeBag = DisposeBag()

    // MARK: - valid
    private var userNameValid = false
    private var emailValid = false
    private var passwordValid = false

    // MARK: 必須入力
    private var userName = ""
    private var email = ""
    private var password = ""


    init(userNameTextFieldObservable: Observable<String>,
         emailTextFieldObservable: Observable<String>,
         passwordTextFieldObservable: Observable<String>,
         registerButtonTapObservable: Observable<Void>,
         profileImageTapButtonObservable: Observable<Void>) {
        self.userNameTextFieldObservable = userNameTextFieldObservable
        self.emailTextFieldObservable = emailTextFieldObservable
        self.passwordTextFieldObservable = passwordTextFieldObservable
        self.registerButtonTapObservable = registerButtonTapObservable
        self.profileImageTapButtonObservable = profileImageTapButtonObservable

        setupBindings()
    }

    private func setupBindings() {

        let userNameValid = userNameTextFieldObservable.asObservable().map { text -> Bool in
            return text.count >= 2
        }

        let emailValid = emailTextFieldObservable.asObservable().map { text -> Bool in
            return text.count >= 5 && text.contains("@gmail.com")
        }
        
        let passwordValid = passwordTextFieldObservable.asObservable().map { text -> Bool in
            return text.count >= 5
        }

        // $0 && $1 && $2のBool値がvalidAllに入る
        Observable.combineLatest(userNameValid, emailValid, passwordValid) { $0 && $1 && $2}.subscribe { validAll in
            self.isValidRegister.onNext(validAll)
        }.disposed(by: disposeBag)

        // 入力のバインド
        Observable.combineLatest(userNameTextFieldObservable, emailTextFieldObservable, passwordTextFieldObservable).subscribe { userName,email,password in
            self.userName = userName
            self.email = email
            self.password = password
        }
        .disposed(by: disposeBag)

        // ボタンタップ、アカウント作成
        registerButtonTapObservable.subscribe(onNext: {
            Task{
                do{
                    try await self.registerUser.registerUserToFirestore(userName: self.userName, email: self.email, password: self.password)
                    print("アカウント作成成功")
                    self.isSuccessCreateUser.onNext(true)
                }
                catch{
                    print("アカウント作成失敗",error)
                    self.isSuccessCreateUser.onError(error)
                }
            }
        })
        .disposed(by: disposeBag)
    }
}

// MARK: - LoginViewModelType
extension LoginViewModel: LoginViewModelType {
    var inputs: LoginViewModelInputs { return self }
    var outputs: LoginViewModelOutputs { return self }

}
