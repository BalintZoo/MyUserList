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
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    let cellReuseIdentifier = "UserCell"
    
    var homeViewModel = MainViewModel(getUserListUseCase:
                                        GetUserListUseCase(usersDataSource:
                                                            UserListDataSourceImpl(remoteStorage: UsersRemoteStorageImpl(),
                                                                                   localStorage: UsersLocalStorageImpl())
                                                          )
    )
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
        
        homeViewModel.requestUserList()
    }
    
    private func setupBindings() {
        
        tableView.rx.modelSelected(UserViewData.self)
           .subscribe(onNext: { [weak self] model in
               guard let self = self else { return }
               //Initialize details view controller fron storyboard with a custom initializer
               if let detailsViewController = self.storyboard?.instantiateViewController(identifier: "DetailsViewControllerID",
                                                                                         creator: { coder in DetailsViewController(userDetails: model, coder: coder) }
               ) as? DetailsViewController {
                   self.navigationController?.pushViewController(detailsViewController, animated: true)
               }
        }).disposed(by: disposeBag)
        
        homeViewModel
            .users
            .observe(on:MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: cellReuseIdentifier)) { row, model, cell in
            if let userCell = cell as? UserTableViewCell {
                userCell.nameLabel?.text = model.fullName
                userCell.emailLabel?.text = model.email
                userCell.userImageView?.kf.setImage(with: model.imageUrl)
            }
        }
        .disposed(by: disposeBag)
        
        homeViewModel
            .loading
            .observe(on: MainScheduler.instance)
            .bind(to: self.activityIndicator.rx.isAnimating).disposed(by: disposeBag)
        
        homeViewModel
            .error
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (error) in
                guard let self = self else { return }
                switch error {
                case .generalError:
                    self.showAlertMessage(title: "Error", message: "Something went wrong, please try again")
                case .networkError(let errorMessage):
                    self.showAlertMessage(title: "Error", message: errorMessage)
                case .noLocalUsers:
                    self.showAlertMessage(title: "Error", message: "Unable to load local user list. Please make sure you have a working internet connection and try again")
                }
            })
            .disposed(by: disposeBag)
    }
}

