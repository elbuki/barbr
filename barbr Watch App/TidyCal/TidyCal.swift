//
//  TidyCal.swift
//  barbr Watch App
//
//  Created by Marco Carmona on 2/8/23.
//

import Foundation

struct TidyCal {
    static let shared = TidyCal()
    
    private var client: Requester
    
    init() {
        let testModeEnabled = ProcessInfo.processInfo.environment["tidycal_test"] == "true"
        
        client = testModeEnabled ? MockClient() : Client()
    }
    
    func getAvailableBookings() async -> [Booking] {
        return await client.getAvailableBookings()
    }
    
    func bookAppointment(userData: Preferences, startsAt date: Date) async -> Appointment {
        return await client.bookAppointment(userData: userData, startsAt: date)
    }
    
    func cancelAppointment(slug: String) async {
        return await client.cancelAppointment(slug: slug)
    }
}
