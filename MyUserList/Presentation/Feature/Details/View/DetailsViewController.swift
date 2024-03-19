//
//  DetailsViewController.swift
//  MyUserList
//
//  Created by Zoltán Bálint on 15.03.2024.
//

import Foundation
import Kingfisher
import RxSwift
import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var fullName: UILabel!
    @IBOutlet var email: UILabel!
    
    private let disposeBag = DisposeBag()
    
    let viewModel: DetailsViewModel
    
    init?(viewModel: DetailsViewModel, coder: NSCoder) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "details".localized
        
        viewModel.user.subscribe { [weak self] userDetails in
            guard let self = self else { return }
            fullName.text = userDetails.fullName
            email.text = userDetails.email
            userImageView.kf.setImage(with: userDetails.imageUrl)
        }
        .disposed(by: disposeBag)
    }
}
