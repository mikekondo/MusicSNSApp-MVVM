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
    @IBOutlet private weak var profileImageButton: UIButton!
    @IBOutlet private weak var userNameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var registerButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!

    // MARK: - ViewModel Connect
    private lazy var loginViewModel = LoginViewModel(userNameTextFieldObservable: userNameTextField.rx.text.map { $0 ?? ""},
                                                     emailTextFieldObservable: emailTextField.rx.text.map { $0 ?? ""},
                                                     passwordTextFieldObservable: passwordTextField.rx.text.map { $0 ?? ""},
                                                     registerButtonTapObservable: registerButton.rx.tap.asObservable(), profileImageTapButtonObservable: profileImageButton.rx.tap.asObservable())

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        registerButton.isEnabled = false

        setupProfileImage()

        // MARK: Binding
        loginViewModel.setupBindings()

        // ボタンの有効化、無効化
        loginViewModel.isValidRegister.subscribe(onNext: { validAll in
            self.registerButton.isEnabled = validAll
        })
        .disposed(by: disposeBag)

        // MainTabBarViewControllerに画面遷移
        loginViewModel.isSuccessCreateUser.subscribe(onNext: { [weak self] success in
            // メインスレッドで実行
            DispatchQueue.main.async {
                let mainTabBar = MainTabBarViewController()
                mainTabBar.modalPresentationStyle = .fullScreen
                self?.present(mainTabBar, animated: true,completion: nil)
            }
        }, onError: { error in
            print("アカウント作成に失敗しました",error)
        })
        .disposed(by: disposeBag)
    }

    private func setupProfileImage() {
        profileImageButton.layer.cornerRadius = profileImageButton.frame.size.height/2
        profileImageButton.layer.borderWidth = 1
    }



    // 写真ライブラリに遷移
    @IBAction func didTapProfileImageButton(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        self.present(imagePickerController, animated: true, completion: nil)
    }
}

extension LoginViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       
        if let editImage = info[.editedImage] as? UIImage{
            profileImageButton.setImage(editImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info[.originalImage] as? UIImage {
            profileImageButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }

        profileImageButton.setTitle("", for: .normal)
        profileImageButton.imageView?.contentMode = .scaleAspectFill
        profileImageButton.contentHorizontalAlignment = .fill
        profileImageButton.contentVerticalAlignment = .fill
        profileImageButton.clipsToBounds = true

        dismiss(animated: true,completion: nil)
    }
}
