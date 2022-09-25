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
    var registerButtonTapObservable: Observable<Void> { get }
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
    var registerButtonTapObservable: Observable<Void>

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
         registerButtonTapObservable: Observable<Void>) {
        self.userNameTextFieldObservable = userNameTextFieldObservable
        self.emailTextFieldObservable = emailTextFieldObservable
        self.passwordTextFieldObservable = passwordTextFieldObservable
        self.registerButtonTapObservable = registerButtonTapObservable
    }

    func setupBindings() {

        let userNameValid = userNameTextFieldObservable.asObservable().map { text -> Bool in
            return text.count >= 5
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


        // ボタンタップ、アカウント作成
        registerButtonTapObservable.subscribe(onNext: {
            self.isSuccessCreateUser.onNext(true)
        })
        .disposed(by: disposeBag)

    }
}
