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
    @IBOutlet var tweetButton: UIButton! {
        didSet {
            self.tweetButton.backgroundColor = Color.secondaryColor
            self.tweetButton.setTitleColor(UIColor.white, for: .normal)
            self.tweetButton.clipsToBounds = true
            self.tweetButton.layer.cornerRadius = 10
        }
    }
    @IBOutlet var exitButton: UIButton!
    @IBOutlet var placeholderLabel: UILabel! {
        didSet {
            self.placeholderLabel.textColor = UIColor.lightGray
        }
    }
    @IBOutlet var tweetTextView: UITextView!
    @IBOutlet var charCountLabel: UILabel! {
        didSet {
            self.charCountLabel.textColor = UIColor.lightGray
        }
    }
    
    //MARK: - Variables
    var disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupExitButton()
        self.setupTweetTextView()
        
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
        self.tweetTextView.rx.text.subscribe(onNext: {
            guard let size = $0?.count else {
                return
            }
            if size == 0 {
                self.placeholderLabel.isHidden = false
            } else {
                if size > AppConfig.MaxCharTweet {
                    self.tweetTextView.text = self.tweetTextView.text.maxCharText
                }
                self.placeholderLabel.isHidden = true
            }
            self.charCountLabel.text = $0?.remainingChar().description
        }).disposed(by: self.disposeBag)
        
    }
    
}
