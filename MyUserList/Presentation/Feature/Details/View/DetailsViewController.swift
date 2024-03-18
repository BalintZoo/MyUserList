//
//  DetailsViewController.swift
//  MyUserList
//
//  Created by Zoltán Bálint on 15.03.2024.
//

import Foundation
import Kingfisher
import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var fullName: UILabel!
    @IBOutlet var email: UILabel!
    
    let userDetails: UserViewData
    
    init?(userDetails: UserViewData, coder: NSCoder) {
        self.userDetails = userDetails
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Details"
        fullName.text = userDetails.fullName
        email.text = userDetails.email
        userImageView.kf.setImage(with: userDetails.imageUrl)
        
    }
}
