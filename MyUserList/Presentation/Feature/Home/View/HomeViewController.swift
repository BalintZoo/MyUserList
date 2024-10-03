//
//  ViewController.swift
//  MyUserList
//
//  Created by Zoltán Bálint on 14.03.2024.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    private let cellReuseIdentifier = "UserCell"
    
    private var homeViewModel = HomeViewModel(getDragonListUseCase:
                                                GetDragonListUseCase(dragonsDataSource:
                                                            DragonListDataSourceImpl(remoteStorage: DragonsRemoteStorageImpl(),
                                                                                   localStorage: DragonsLocalStorageImpl())
                                                          )
    )
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "users".localized
        
        checkAuthentication()
        
        setupBindings()
        
        homeViewModel.requestDragonList()
    }
    
    func checkAuthentication() {
        if LoginManager.shared.getToken() == nil {
           let loginVC = LoginViewController()
           loginVC.title = "Login"
           let navController = UINavigationController(rootViewController: loginVC)
           present(navController, animated: true, completion: nil)
       } else {
           homeViewModel.requestDragonList()
       }

       NotificationCenter.default.addObserver(
           self,
           selector: #selector(loginSucceeded),
           name: .loginSuccess,
           object: nil
       )
    }
        
    @objc func loginSucceeded() {
        dismiss(animated: true)
        homeViewModel.requestDragonList()
    }
    
    private func setupBindings() {
        
        tableView.rx.modelSelected(DragonViewData.self)
           .subscribe(onNext: { [weak self] model in
               guard let self = self else { return }
               
               //Initialize details view controller from storyboard with a custom initializer
               let detailsViewModel = DetailsViewModel(userData: model)
               if let detailsViewController = self.storyboard?.instantiateViewController(identifier: "DetailsViewControllerID",
                                                                                         creator: { coder in DetailsViewController(viewModel: detailsViewModel,
                                                                                                                                   coder: coder) }
               ) as? DetailsViewController {
                   self.navigationController?.pushViewController(detailsViewController, animated: true)
               }
               //-----------------------------------------------------------------------------
        }).disposed(by: disposeBag)
        
        homeViewModel
            .users
            .observe(on:MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: cellReuseIdentifier)) { row, model, cell in
            if let userCell = cell as? UserTableViewCell {
                userCell.nameLabel?.text = model.name
                userCell.userImageView?.kf.setImage(with: model.imageUrl,
                                                    placeholder: UIImage(named: "user"),
                                                    options: [.cacheMemoryOnly])
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
                // @BZ get rid of this switch by implementing localizederror
                switch error {
                case .generalError:
                    self.showAlertMessage(title: "error".localized, message: "general_error".localized)
                case .networkError(let errorMessage):
                    self.showAlertMessage(title: "error".localized, message: errorMessage)
                case .noLocalData:
                    self.showAlertMessage(title: "error".localized, message: "no_local_data".localized)
                }
            })
            .disposed(by: disposeBag)
    }
}

