//
//  LoginViewController.swift
//  Blackbird
//
//  Created by Eric Labaci on 2/22/18.
//  Copyright © 2018 Blackbird. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import FirebaseAuth

class LoginViewController: BaseViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            self.emailTextField.returnKeyType = .next
            self.emailTextField.keyboardType = .emailAddress
        }
    }
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            self.passwordTextField.returnKeyType = .go
            self.passwordTextField.isSecureTextEntry = true
        }
    }
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var loginButton: UIButton! {
        didSet {
            self.loginButton.isEnabled = false
        }
    }
    @IBOutlet weak var registerButton: UIButton!
    
    //MARK: - Variables
    private let disposeBag = DisposeBag()
    
    //MARK: - VC Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTextFieldHandling()
        self.setupButtonHandling()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        //Dismiss keyboard
        self.view.endEditing(true)
    }
    
    //MARK: - Rx Setup
    private func setupTextFieldHandling() {
        //MARK: Email text field
        let isEmailValid = self.emailTextField.rx.text.map { email in
            return email?.isValidEmail
        }
        
        self.emailTextField.rx.controlEvent(UIControlEvents.editingDidEndOnExit).subscribe(onNext: { [weak self] in
            //Go to password text field
            self?.passwordTextField.becomeFirstResponder()
        }).disposed(by: self.disposeBag)
        
        //MARK: Password text field
        let isPasswordValid = self.passwordTextField.rx.text.map { password in
            return password?.isValidPassword
        }
        
        self.passwordTextField.rx.controlEvent(UIControlEvents.editingDidEndOnExit).subscribe(onNext: { [weak self] in
            //Dismiss keyboard
            self?.passwordTextField.resignFirstResponder()
        }).disposed(by: self.disposeBag)
        
        //MARK: Login Button
        let shouldEnableButton = Observable.combineLatest(isEmailValid, isPasswordValid) { isEmailValid, isPasswordValid in
            return (isEmailValid ?? false) && (isPasswordValid ?? false)
        }
        
        shouldEnableButton.subscribe(onNext: { [weak self] enabled in
            self?.loginButton.isEnabled = enabled
        }).disposed(by: self.disposeBag)
    }
    
    private func setupButtonHandling() {
        self.loginButton.rx.controlEvent(UIControlEvents.touchUpInside).subscribe(onNext: { [weak self] in
            guard let email = self?.emailTextField.text, let password = self?.passwordTextField.text else {
                return
            }
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else if let user = user {
                    print("\(user)")
                    let storyboard = UIStoryboard(name: Storyboard.TabBar, bundle: nil)
                    if let initialVC = storyboard.instantiateInitialViewController() {
                        self?.present(initialVC, animated: true, completion: nil)
                    }
                }
            })
        }).disposed(by: self.disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
}
