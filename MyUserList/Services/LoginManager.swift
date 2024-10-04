//
//  AuthManager.swift
//  MyUserList
//
//  Created by Zoltan Balint on 03.10.2024.
//

import Foundation
import Alamofire
import UIKit

protocol TokenProvider {
    func getToken() -> String?
    func setToken(token: String)
    func removeToken()
}

class LoginManager {
    
    static let shared = LoginManager()

    private init() { }

    private let tokenKey = "accessToken"
    
    // Existing properties
    private let clientID = "ruhrbahn_app"
    private let scopes = ["openid"]
    private let redirectURL = "de.evag://callback"
    private let authorizationURL = "https://iam.beta.handyticket.link/realms/ruhrbahn_essen/protocol/openid-connect/auth"
    private let tokenURL = "https://iam.beta.handyticket.link/realms/ruhrbahn_essen/protocol/openid-connect/token"

    // Add a property to hold the completion handler
    private var loginCompletion: ((Result<String, Error>) -> Void)?

    // Method to initiate the OIDC login
    func login(completion: @escaping (Result<String, Error>) -> Void) {
        self.loginCompletion = completion
        let authRequest = buildAuthRequest()
        openAuthURL(authRequest)
    }
    
    // Build the authorization URL request
    private func buildAuthRequest() -> URL {
        var components = URLComponents(string: authorizationURL)!
        components.queryItems = [
            URLQueryItem(name: "client_id", value: clientID),
            URLQueryItem(name: "scope", value: scopes.joined(separator: " ")),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "redirect_uri", value: redirectURL)
        ]

        return components.url!
    }

    // Open the authorization URL in a browser
    private func openAuthURL(_ url: URL) {
        DispatchQueue.main.async {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                print("Cannot open URL: \(url)")
            }
        }
    }

    // Handle the redirect with the authorization code
    func handleRedirect(url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let code = components.queryItems?.first(where: { $0.name == "code" })?.value else {
            loginCompletion?(.failure(OIDCError.invalidRedirect))
            return
        }
        
        exchangeCodeForToken(code: code)
    }

    private func exchangeCodeForToken(code: String) {
        var request = URLRequest(url: URL(string: tokenURL)!)
        request.httpMethod = "POST"
        let body = "grant_type=authorization_code&code=\(code)&redirect_uri=\(redirectURL)&client_id=\(clientID)"
        request.httpBody = body.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                self.loginCompletion?(.failure(error))
                return
            }

            guard let data = data else {
                self.loginCompletion?(.failure(OIDCError.noData))
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let accessToken = json["access_token"] as? String {
                    self.setToken(token: accessToken)
                    self.loginCompletion?(.success(accessToken))
                } else {
                    self.loginCompletion?(.failure(OIDCError.invalidResponse))
                }
            } catch {
                self.loginCompletion?(.failure(error))
            }
        }
        task.resume()
    }

    enum OIDCError: Error {
        case invalidRedirect
        case noData
        case invalidResponse
    }
}
 
extension LoginManager: TokenProvider {
    func setToken(token: String) {
        if let tokenData = token.data(using: .utf8) {
            KeychainHelper.shared.save(tokenData, forKey: tokenKey)
        }
    }
    
    func removeToken() {
        KeychainHelper.shared.delete(forKey: tokenKey)
    }
    
    func getToken() -> String? {
        if let tokenData = KeychainHelper.shared.read(forKey: tokenKey) {
            return String(data: tokenData, encoding: .utf8)
        }
        return nil
    }
}

class AuthInterceptor: RequestInterceptor {
    private let tokenProvider: TokenProvider

    init(tokenProvider: TokenProvider = LoginManager.shared) {
        self.tokenProvider = tokenProvider
    }

    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest

        if let token = tokenProvider.getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        completion(.success(request))
    }

    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        completion(.doNotRetry)
    }
}
