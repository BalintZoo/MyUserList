//
//  String+Extensions.swift
//  MyUserList
//
//  Created by Zoltán Bálint on 18.03.2024.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "\(self)_comment")
    }
}
