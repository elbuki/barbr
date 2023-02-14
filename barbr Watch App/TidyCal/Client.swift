//
//  Client.swift
//  barbr Watch App
//
//  Created by Marco Carmona on 2/8/23.
//

import Foundation

struct Client: Requester {

    func getAvailableBookings() -> [Booking] {
        return []
    }
    
    func bookAppointment(startsAt timestamp: Date) -> Appointment {
        // TODO: Create implementation
        return .init(id: 0, startsAt: .now, endsAt: .now)
    }

}
