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
        
        let appointmentRawValue = current.object(forKey: Self.Keys.appointment.rawValue)

        guard let appointment = appointmentRawValue as? Appointment else {
            return
        }
        
        savedAppointment = appointment
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
    
    var savedAppointment: Appointment? {
        willSet {
            guard let appointment = newValue else { return }
            
            current.set(appointment, forKey: Self.Keys.appointment.rawValue)
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
