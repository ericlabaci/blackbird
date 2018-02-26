//
//  MyProfileViewController.swift
//  Blackbird
//
//  Created by Raphael Carletti on 2/26/18.
//  Copyright © 2018 Blackbird. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class MyProfileViewController : BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    let viewModel = MyProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Table View Cell Register
        self.tableView.register(BlackBirdTableViewCell.self, forCellReuseIdentifier: Identifiers.blackBirdCell)
        self.tableView.register(UINib(nibName: String(describing: BlackBirdTableViewCell.self), bundle: nil), forCellReuseIdentifier: Identifiers.blackBirdCell)
        
        //Setting delegate and header height to be automatic and separator
        self.tableView.rx.setDelegate(self).disposed(by: self.disposeBag)
        self.tableView.estimatedSectionHeaderHeight = 200.0
        self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        self.tableView.separatorStyle = .none
        
        //RX
        self.setUpTableViewRX()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        self.viewModel.stopAllListeners()
    }
    
    
    func setUpTableViewRX() {
        self.viewModel.blackBird.asObservable().bind(to: self.tableView.rx.items(cellIdentifier: Identifiers.blackBirdCell, cellType: BlackBirdTableViewCell.self)) {
            row, blackbird, cell in
                cell.configureCellWith(blackBird: blackbird)
        }.disposed(by: self.disposeBag)
    }
    
}

//MARK: - Table View Delegate
extension MyProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return ProfileCard()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
       return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
}
