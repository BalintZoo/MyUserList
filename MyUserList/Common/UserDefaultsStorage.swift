//
//  UserDefaultsStorage.swift
//  MyUserList
//
//  Created by Zoltán Bálint on 19.03.2024.
//

import Combine
import Foundation
import SwiftUI

@propertyWrapper
public final class UserDefaultStorage<T: Codable>: NSObject {
    private let key: String
    private let defaultValue: T
    private let subject: CurrentValueSubject<T, Never>
    private let userDefaults: UserDefaults
    private var observerContext = 0
 
    public init(key: String, default: T, store: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = `default`
        self.userDefaults = store
        self.subject = CurrentValueSubject(defaultValue)
        super.init()
        userDefaults.addObserver(self, forKeyPath: key, options: .new, context: &observerContext)
        subject.value = wrappedValue
    }
 
    public var wrappedValue: T {
        get {
            guard let data = userDefaults.data(forKey: key) else {
                return defaultValue
            }
            let value = try? JSONDecoder().decode(T.self, from: data)
            return value ?? defaultValue
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            userDefaults.set(data, forKey: key)
        }
    }
 
    public var projectedValue: AnyPublisher<T, Never> {
        return subject.eraseToAnyPublisher()
    }
 
    public override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey: Any]?,
        context: UnsafeMutableRawPointer?) {
        if context == &observerContext {
            subject.value = wrappedValue
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
 
    deinit {
        userDefaults.removeObserver(self, forKeyPath: key, context: &observerContext)
    }
}
