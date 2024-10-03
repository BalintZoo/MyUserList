//
//  LoginViewController.swift
//  MyUserList
//
//  Created by Zoltan Balint on 03.10.2024.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - UI Elements

    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login with RuhrBahn", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupActions()
    }

    // MARK: - UI Setup

    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(loginButton)

        NSLayoutConstraint.activate([
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.widthAnchor.constraint(equalToConstant: 200)
        ])
    }

    // MARK: - Actions Setup
    
    private func setupActions() {
        loginButton.addTarget(self, action: #selector(startLogin), for: .touchUpInside)
    }

    // MARK: - Login Action
    
    @objc private func startLogin() {
        LoginManager.shared.login { [weak self] result in
            switch result {
            case .success(let token):
                print("Login successful. Access token: \(token)")
                DispatchQueue.main.async {
                    self?.dismiss(animated: true, completion: nil)
                }
            case .failure(let error):
                self?.presentLoginError(error)
            }
        }
    }

    // MARK: - Error Handling
    
    private func presentLoginError(_ error: Error) {
        let alert = UIAlertController(title: "Login Failed", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
            self?.startLogin()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
}
