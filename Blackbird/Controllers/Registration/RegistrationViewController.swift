//
//  RegistrationViewController.swift
//  Blackbird
//
//  Created by Eric Labaci on 2/22/18.
//  Copyright © 2018 Blackbird. All rights reserved.
//

import UIKit
import AVKit
import RxSwift
import RxCocoa
import FirebaseDatabase
import FirebaseStorage

class RegistrationViewController: BaseViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var profileImageButton: UIButton!{
        didSet {
            self.profileImageButton.layer.cornerRadius = self.profileImageButton.frame.width / 2
            self.profileImageButton.clipsToBounds = true
            self.profileImageButton.setTitle(nil, for: .normal)
            self.profileImageButton.imageView?.contentMode = .scaleAspectFill
            self.profileImageButton.setImage(UIImage(named: Images.ProfileDefault), for: .normal)
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
    
    @IBOutlet weak var registerButton: UIButton! {
        didSet {
            self.registerButton.isEnabled = false
        }
    }
    
    //MARK: - Variables
    let registrationViewModel = RegistrationViewModel()
    
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
        
        self.nameTextField.rx.text.subscribe(onNext: { [weak self] name in
            self?.registrationViewModel.name = name ?? ""
        }).disposed(by: self.disposeBag)
        
        self.nameTextField.rx.controlEvent(UIControlEvents.editingDidEndOnExit).subscribe(onNext: { [weak self] in
            self?.userNameTextField.becomeFirstResponder()
        }).disposed(by: self.disposeBag)
        
        //MARK: User Name
        let isUserNameValid = self.userNameTextField.rx.text.map { userName in
            return userName?.isValidUserName
        }
        
        self.userNameTextField.rx.text.subscribe(onNext: { [weak self] userName in
            self?.registrationViewModel.userName = userName ?? ""
        }).disposed(by: self.disposeBag)
        
        self.userNameTextField.rx.controlEvent(UIControlEvents.editingDidEndOnExit).subscribe(onNext: { [weak self] in
            self?.emailTextField.becomeFirstResponder()
        }).disposed(by: self.disposeBag)
        
        //MARK: E-mail
        let isEmailValid = self.emailTextField.rx.text.map { name in
            return name?.isValidEmail
        }
        
        self.emailTextField.rx.text.subscribe(onNext: { [weak self] email in
            self?.registrationViewModel.email = email ?? ""
        }).disposed(by: self.disposeBag)
        
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
        
        self.passwordTextField.rx.text.subscribe(onNext: { [weak self] password in
            self?.registrationViewModel.password = password ?? ""
        }).disposed(by: self.disposeBag)
        
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
            self?.registerButton.isEnabled = enabled
        }).disposed(by: self.disposeBag)
    }
    
    private func setupButtonHandling() {
        //MARK: Profile Image
        self.profileImageButton.rx.controlEvent(UIControlEvents.touchUpInside).subscribe(onNext: { [weak self] in
            let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { (action) in
                self?.openCamera(completion: {
                    let imagePickerController = UIImagePickerController()
                    imagePickerController.sourceType = .camera
                    imagePickerController.delegate = self
                    
                    self?.present(imagePickerController, animated: true, completion: nil)
                })
            })
            let libraryAction = UIAlertAction(title: "Library", style: .default, handler: { (action) in
                self?.openGallery(completion: {
                    let imagePickerController = UIImagePickerController()
                    imagePickerController.sourceType = .photoLibrary
                    imagePickerController.delegate = self
                    
                    self?.present(imagePickerController, animated: true, completion: nil)
                })
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            actionSheetController.addAction(cameraAction)
            actionSheetController.addAction(libraryAction)
            actionSheetController.addAction(cancelAction)
            
            self?.present(actionSheetController, animated: true, completion: nil)
        }).disposed(by: self.disposeBag)
        
        //MARK: Register
        self.registerButton.rx.controlEvent(UIControlEvents.touchUpInside).subscribe(onNext: { [weak self] in
            self?.registrationViewModel.register(success: {
                NavigationUtils.goToHome()
            }, failure: { (error) in
                self?.present(AlertControllerUtils.getOKAlertController(code: .RegisterFailed, okCompletion: nil), animated: true, completion: nil)
            })
        }).disposed(by: self.disposeBag)
    }
}

extension RegistrationViewController : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.profileImageButton.setImage(image, for: .normal)
            self.registrationViewModel.profileImage = image
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}
