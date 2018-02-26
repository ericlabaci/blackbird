//
//  RegistrationViewController.swift
//  Blackbird
//
//  Created by Eric Labaci on 2/22/18.
//  Copyright © 2018 Blackbird. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
//import FirebaseFirestore

class RegistrationViewController: BaseViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var profileImageView: UIImageView!{
        didSet {
            self.profileImageView.layer.cornerRadius = self.profileImageView.frame.width / 2
            self.profileImageView.clipsToBounds = true
            self.profileImageView.image = UIImage(named: Images.ProfileDefault)
        }
    }
    @IBOutlet weak var nameTextField: UITextField! {
        didSet {
            self.nameTextField.returnKeyType = .next
            self.nameTextField.autocapitalizationType = .words
        }
    }
    @IBOutlet weak var userNameTextField: UITextField! {
        didSet {
            self.userNameTextField.returnKeyType = .next
        }
    }
    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            self.emailTextField.keyboardType = .emailAddress
            self.emailTextField.returnKeyType = .next
        }
    }
    @IBOutlet weak var repeatEmailTextField: UITextField! {
        didSet {
            self.repeatEmailTextField.keyboardType = .emailAddress
            self.repeatEmailTextField.returnKeyType = .next
        }
    }
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            self.passwordTextField.isSecureTextEntry = true
            self.passwordTextField.returnKeyType = .next
        }
    }
    @IBOutlet weak var repeatPasswordTextField: UITextField! {
        didSet {
            self.repeatPasswordTextField.isSecureTextEntry = true
            self.repeatPasswordTextField.returnKeyType = .done
        }
    }
    
    @IBOutlet weak var registerButtons: UIButton! {
        didSet {
            self.registerButtons.isEnabled = false
        }
    }
    
    //MARK: - VC Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTextFieldHandling()
        self.setupButtonHandling()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.view.endEditing(true)
    }
    
    //MARK: - Rx Setup
    private func setupTextFieldHandling() {
        //MARK: Name
        let isNameValid = self.nameTextField.rx.text.map { name in
            return name?.isValidName
        }
        
        self.nameTextField.rx.controlEvent(UIControlEvents.editingDidEndOnExit).subscribe(onNext: { [weak self] in
            self?.userNameTextField.becomeFirstResponder()
        }).disposed(by: self.disposeBag)
        
        //MARK: User Name
        let isUserNameValid = self.userNameTextField.rx.text.map { userName in
            return userName?.isValidUserName
        }
        
        self.userNameTextField.rx.controlEvent(UIControlEvents.editingDidEndOnExit).subscribe(onNext: { [weak self] in
            self?.emailTextField.becomeFirstResponder()
        }).disposed(by: self.disposeBag)
        
        //MARK: E-mail
        let isEmailValid = self.emailTextField.rx.text.map { name in
            return name?.isValidEmail
        }
        
        self.emailTextField.rx.controlEvent(UIControlEvents.editingDidEndOnExit).subscribe(onNext: { [weak self] in
            self?.repeatEmailTextField.becomeFirstResponder()
        }).disposed(by: self.disposeBag)
        
        //MARK: Repeat E-mail
        let isRepeatEmailCorrect = self.repeatEmailTextField.rx.text.map { [weak self] repeatEmail in
            return repeatEmail == self?.emailTextField.text
        }
        
        self.repeatEmailTextField.rx.controlEvent(UIControlEvents.editingDidEndOnExit).subscribe(onNext: { [weak self] in
            self?.passwordTextField.becomeFirstResponder()
        }).disposed(by: self.disposeBag)
        
        //MARK: Password
        let isPasswordValid = self.passwordTextField.rx.text.map { password in
            return password?.isValidPassword
        }
        
        self.passwordTextField.rx.controlEvent(UIControlEvents.editingDidEndOnExit).subscribe(onNext: { [weak self] in
            self?.repeatPasswordTextField.becomeFirstResponder()
        }).disposed(by: self.disposeBag)
        
        //MARK: Repeat Password
        let isRepeatPasswordCorrect = self.repeatPasswordTextField.rx.text.map { [weak self] repeatPassword in
            return repeatPassword == self?.passwordTextField.text
        }
        
        self.repeatPasswordTextField.rx.controlEvent(UIControlEvents.editingDidEndOnExit).subscribe(onNext: { [weak self] in
            self?.repeatPasswordTextField.resignFirstResponder()
        }).disposed(by: self.disposeBag)
        
        //MARK: Register Button
        let shouldEnableButton = Observable.combineLatest(isNameValid, isUserNameValid, isEmailValid, isRepeatEmailCorrect, isPasswordValid, isRepeatPasswordCorrect) {
            (isNameValid, isUserNameValid, isEmailValid, isRepeatEmailCorrect, isPasswordValid, isRepeatPasswordCorrect) in
            return (isNameValid ?? false) && (isUserNameValid ?? false) && (isEmailValid ?? false) && isRepeatEmailCorrect && (isPasswordValid ?? false) && isRepeatPasswordCorrect
        }
        
        shouldEnableButton.subscribe(onNext: { [weak self] (enabled) in
            self?.registerButtons.isEnabled = enabled
        }).disposed(by: self.disposeBag)
    }
    
    private func setupButtonHandling() {
        self.registerButtons.rx.controlEvent(UIControlEvents.touchUpInside).subscribe(onNext: { [weak self] in
            guard let email = self?.emailTextField.text, let password = self?.passwordTextField.text, let name = self?.nameTextField.text, let userName = self?.userNameTextField.text else {
                return
            }
            FirebaseUtils.register(email: email, password: password, name: name, userName: userName, success: { (user) in
                NavigationUtils.goToHome()
            }, failure: { (error) in
                self?.present(AlertControllerUtils.getOKAlertController(code: .RegisterFailed, okCompletion: nil), animated: true, completion: nil)
            })
        }).disposed(by: self.disposeBag)
    }
}
