//
//  HomeViewController.swift
//  Blackbird
//
//  Created by Raphael Carletti on 2/22/18.
//  Copyright © 2018 Blackbird. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: BaseViewController {
    //MARK: - IBOutlets
    @IBOutlet var tableView: UITableView!
    @IBOutlet var addTweetButton: UIBarButtonItem!
    
    //MARK: - Variables
    var disposeBag: DisposeBag = DisposeBag()
    var homeViewModel : HomeViewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Title Nav Bar
        let imageView = UIImageView(image: #imageLiteral(resourceName: "blackbird-main"))
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
        
        //Table View Cell Register
        self.tableView.register(TweetTableViewCell.self, forCellReuseIdentifier: Identifiers.tweetCell)
        self.tableView.register(UINib(nibName: String(describing: TweetTableViewCell.self), bundle: nil), forCellReuseIdentifier: Identifiers.tweetCell)
        
        //RX
        self.setupTableViewRX()
        self.setupAddTweetButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupTableViewRX() {
        self.homeViewModel.tweets.asObservable().bind(to: tableView.rx.items(cellIdentifier: Identifiers.tweetCell, cellType: TweetTableViewCell.self)) {
            (row, tweet, cell) in
                cell.configureCellWith(tweet: tweet)
        }.disposed(by: disposeBag)
    }
    
    func setupAddTweetButton() {
        self.addTweetButton.rx.tap.subscribe(onNext: {
            let storyboard = UIStoryboard(name: Storyboard.Home, bundle: nil)
            let newTweetVC = storyboard.instantiateViewController(withIdentifier: ViewControllers.NewTweet)
            self.present(newTweetVC, animated: true, completion: nil)
        }).disposed(by: disposeBag)
    }
    
}
