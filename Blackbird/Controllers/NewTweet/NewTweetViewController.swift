//
//  NewTweetViewController.swift
//  Blackbird
//
//  Created by Raphael Carletti on 2/22/18.
//  Copyright © 2018 Blackbird. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class NewTweetViewController : BaseViewController {
    //MARK: - IBOutlets
    @IBOutlet var blackBirdButton: UIButton! {
        didSet {
            self.blackBirdButton.backgroundColor = Color.secondaryColor
            self.blackBirdButton.setTitleColor(UIColor.white, for: .normal)
            self.blackBirdButton.clipsToBounds = true
            self.blackBirdButton.layer.cornerRadius = 10
        }
    }
    @IBOutlet var exitButton: UIButton!
    @IBOutlet var placeholderLabel: UILabel! {
        didSet {
            self.placeholderLabel.textColor = UIColor.lightGray
        }
    }
    @IBOutlet var blackBirdTextView: UITextView!
    @IBOutlet var charCountLabel: UILabel! {
        didSet {
            self.charCountLabel.textColor = UIColor.lightGray
        }
    }
    
    //MARK: - Variables
    var viewModel: NewTweetViewModel = NewTweetViewModel()
    
    //MARK: - VC Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupExitButton()
        self.setupTweetTextView()
        self.setupBlackBirdIt()
        self.blackBirdTextView.becomeFirstResponder()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupExitButton() {
        self.exitButton.rx.controlEvent(UIControlEvents.touchUpInside).subscribe(onNext: {
            self.view.endEditing(true)
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: self.disposeBag)
    }
    
    func setupTweetTextView() {
        self.blackBirdTextView.rx.text.subscribe(onNext: {
            guard let size = $0?.count else {
                return
            }
            if size == 0 {
                self.placeholderLabel.isHidden = false
            } else {
                if size > AppConfig.MaxCharTweet {
                    self.blackBirdTextView.text = self.blackBirdTextView.text.maxCharText
                }
                self.placeholderLabel.isHidden = true
            }
            self.charCountLabel.text = $0?.remainingChar.description
            self.viewModel.text = $0
        }).disposed(by: self.disposeBag)
        
    }
    
    
    func setupBlackBirdIt() {
        self.viewModel.time = Date()
        self.blackBirdButton.rx.controlEvent(UIControlEvents.touchUpInside).subscribe(onNext: {
            self.viewModel.addTweetToFirebase(success: {
                self.dismiss(animated: true, completion: nil)
            }, failure: { (error) in
                let alertController = UIAlertController(title: "Error while sending to firebase", message: "", preferredStyle: .alert)
                let actionOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertController.addAction(actionOk)
                self.present(alertController, animated: true, completion: nil)
            })
        }).disposed(by: self.disposeBag)
    }
    
}
