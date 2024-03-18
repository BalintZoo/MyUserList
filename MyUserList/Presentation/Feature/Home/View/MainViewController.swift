//
//  ViewController.swift
//  MyUserList
//
//  Created by Zoltán Bálint on 14.03.2024.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    let cellReuseIdentifier = "UserCell"
    
    var homeViewModel = MainViewModel(getUserListUseCase: GetUserListUseCase(usersDataSource: UserListRemoteDataSourceImpl()))
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeViewModel.users.bind(to: tableView.rx.items(cellIdentifier: cellReuseIdentifier)) { row, model, cell in
            if let userCell = cell as? UserTableViewCell {
                userCell.nameLabel?.text = model.fullName
                userCell.emailLabel?.text = model.email
                userCell.userImageView?.kf.setImage(with: model.imageUrl)
            }
        }
        .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(UserViewData.self)
           .subscribe(onNext: { [weak self] model in
               if let detailsViewController = self?.storyboard?.instantiateViewController(identifier: "DetailsViewControllerID",
                                                                                         creator: { coder in
                   DetailsViewController(userDetails: model,
                   coder: coder)
               }) as? DetailsViewController {
                   self?.navigationController?.pushViewController(detailsViewController, animated: true)
               }
        }).disposed(by: disposeBag)
        
        homeViewModel.requestUserList()
    }
}

