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
    
    func getAvailableBookings() -> [Booking] {
        return client.getAvailableBookings()
    }
}
