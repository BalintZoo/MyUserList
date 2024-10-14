//
//  ViewController.swift
//  MyUserList
//
//  Created by Zoltán Bálint on 14.03.2024.
//

import UIKit
import RxSwift
import RxCocoa

/// The main landing page of the app with the list of items
/// Would be interesting exercise to re-write the UIKit into a full SwiftUI app, it's a good practice for a lot of real world projects out there
class HomeViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    private let cellReuseIdentifier = "UserCell"
    
    /// This definetly needs to be more pretty, with some nice DI implementation for ex.
    private var homeViewModel = HomeViewModel(getDragonListUseCase:
                                                GetDragonListUseCase(dragonsDataSource:
                                                            DragonListDataSourceImpl(remoteStorage: DragonsRemoteStorageImpl(),
                                                                                   localStorage: DragonsLocalStorageImpl())
                                                          )
    )
    
    lazy private var loginVC = LoginViewController()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "users".localized
        
        loginVC.title = "Login"
        
        checkAuthentication()
        
        setupBindings()        
    }
        
    func checkAuthentication() {
        if LoginManager.shared.getToken() == nil {
            presentLogin()
        } else {
            homeViewModel.requestDragonList()
        }
    }
        
    @objc func loginSucceeded() {
        DispatchQueue.main.async { [weak self] in
            self?.dismiss(animated: true)
        }
        
    }
    
    private func setupBindings() {
        
        loginVC.loginFinished
                    .observe(on: MainScheduler.instance)
                    .subscribe(onNext: { [weak self] result in
                        switch result {
                        case .success(let token):
                            self?.dismiss(animated: true)
                            self?.homeViewModel.requestDragonList()
                        case .failure(let error):
                            self?.presentLoginError(error)
                        }
                    })
                    .disposed(by: disposeBag)
        
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
            .dragons
            .observe(on:MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: cellReuseIdentifier)) { row, model, cell in
            if let userCell = cell as? DragonTableViewCell {
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
                self.showAlertMessage(title: "error".localized, message: error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Error Handling
    
    private func presentLoginError(_ error: Error) {
        let alert = UIAlertController(title: "Login Failed", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
            self?.presentLogin()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { [weak self] _ in
            // Try to load even if login failed, to get the offline saved list if available
            self?.homeViewModel.requestDragonList()
        })
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    private func presentLogin() {
        let navController = UINavigationController(rootViewController: loginVC)
        present(navController, animated: true, completion: nil)
    }
}

