//
//  UserPreferences.swift
//  barbr Watch App
//
//  Created by Marco Carmona on 2/9/23.
//

import Foundation

class UserPreferences: ObservableObject {
    private let current = UserDefaults.standard
    
    init() {
        name = current.string(forKey: Self.Keys.name.rawValue)
        email = current.string(forKey: Self.Keys.email.rawValue)
        phone = current.integer(forKey: Self.Keys.phone.rawValue)
    }

    var name: String? {
        willSet {
            current.set(newValue, forKey: Self.Keys.name.rawValue)
        }
    }
    
    var email: String? {
        willSet {
            current.set(newValue, forKey: Self.Keys.email.rawValue)
        }
    }
    
    var phone: Int? {
        willSet {
            current.set(newValue, forKey: Self.Keys.phone.rawValue)
        }
    }
    
    var isInitialized: Bool {
        return name != nil && email != nil && phone != nil
    }
}

extension UserPreferences {
    
    enum Keys: String {
        case name = "name"
        case email = "email"
        case phone = "phone"
    }
    
}
