//
//  Appointment.swift
//  barbr Watch App
//
//  Created by Marco Carmona on 2/14/23.
//

import Foundation

struct Appointment: Codable {
    let id: Int
    let slug: String
    let startsAt: Date
    let endsAt: Date
    
    func encodeToJSON() throws -> Data {
        let encoder = JSONEncoder()
        
        let formatter = ISO8601DateFormatter()
        
        formatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds,
        ]
        
        encoder.dateEncodingStrategy = .custom({ date, encoder in
            var container = encoder.singleValueContainer()
            let dateString = formatter.string(from: date)
            
            try container.encode(dateString)
        })
        
        return try encoder.encode(self)
    }
}
