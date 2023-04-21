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
        client = MockClient()
        
        do {
            if let filePath = Bundle.main.path(forResource: "config", ofType: "json") {
                let fileURL = URL(fileURLWithPath: filePath)
                let data = try Data(contentsOf: fileURL)
                let decoded = try JSONDecoder().decode(Config.self, from: data)

                if decoded.testMode {
                    return
                }
                
                client = Client(config: decoded)
            }
        } catch {
            fatalError("could not get json: \(error)")
        }
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
