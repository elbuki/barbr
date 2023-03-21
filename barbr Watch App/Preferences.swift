//
//  Preferences.swift
//  barbr Watch App
//
//  Created by Marco Carmona on 2/9/23.
//

import Foundation

class Preferences: ObservableObject {
    private let current = UserDefaults.standard
    
    init() {
        name = current.string(forKey: Self.Keys.name.rawValue)
        email = current.string(forKey: Self.Keys.email.rawValue)
        phone = current.integer(forKey: Self.Keys.phone.rawValue)
        
        let rawData = current.data(forKey: Self.Keys.appointment.rawValue)

        guard let rawData else {
            return
        }
        
        guard let decoded = try? Decoder.shared.decode(Appointment.self, from: rawData) else {
            return
        }
        
        savedAppointment = decoded
    }

    @Published var name: String? {
        willSet {
            current.set(newValue, forKey: Self.Keys.name.rawValue)
        }
    }
    
    @Published var email: String? {
        willSet {
            current.set(newValue, forKey: Self.Keys.email.rawValue)
        }
    }
    
    @Published var phone: Int? {
        willSet {
            current.set(newValue, forKey: Self.Keys.phone.rawValue)
        }
    }
    
    @Published var savedAppointment: Appointment? {
        willSet {
            guard let appointment = newValue else {
                current.removeObject(forKey: Self.Keys.appointment.rawValue)
                return
            }
            
            guard let data = try? appointment.encodeToJSON() else {
                fatalError("Could not encode to JSON")
            }
            
            current.set(data, forKey: Self.Keys.appointment.rawValue)
        }
    }
    
    var isUserInitialized: Bool {
        return name != nil && email != nil && phone != nil
    }
}

extension Preferences {
    
    enum Keys: String {
        case name = "name"
        case email = "email"
        case phone = "phone"
        case appointment = "appointment"
    }
    
}
