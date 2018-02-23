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
    @IBOutlet var tableView: UITableView! {
        didSet {
            self.tableView.separatorStyle = .none
        }
    }
    @IBOutlet var addTweetButton: UIBarButtonItem!
    
    //MARK: - Variables
    var homeViewModel : HomeViewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Title Nav Bar
        let imageView = UIImageView(image: #imageLiteral(resourceName: "blackbird-main"))
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
        
        //Table View Cell Register
        self.tableView.register(BlackBirdTableViewCell.self, forCellReuseIdentifier: Identifiers.blackBirdCell)
        self.tableView.register(UINib(nibName: String(describing: BlackBirdTableViewCell.self), bundle: nil), forCellReuseIdentifier: Identifiers.blackBirdCell)
        
        //RX
        self.setupTableViewRX()
        self.setupAddTweetButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupTableViewRX() {
        self.homeViewModel.blackBird.asObservable().bind(to: tableView.rx.items(cellIdentifier: Identifiers.blackBirdCell, cellType: BlackBirdTableViewCell.self)) {
            (row, blackBird, cell) in
                cell.configureCellWith(blackBird: blackBird)
        }.disposed(by: disposeBag)
    }
    
    func setupAddTweetButton() {
        self.addTweetButton.rx.tap.subscribe(onNext: { [weak self] in
            let storyboard = UIStoryboard(name: Storyboard.Home, bundle: nil)
            let newTweetVC = storyboard.instantiateViewController(withIdentifier: ViewControllers.NewTweet)
            self?.present(newTweetVC, animated: true, completion: nil)
        }).disposed(by: disposeBag)
    }
    
}
