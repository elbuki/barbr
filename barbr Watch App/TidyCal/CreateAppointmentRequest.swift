//
//  CreateAppointmentRequest.swift
//  barbr Watch App
//
//  Created by Marco Carmona on 2/14/23.
//

import Foundation

struct CreateAppointmentRequest: Encodable {
    let method: String
    let name: String
    let email: String
    let startsAt: Date
    let questions: [AppointmentQuestion]
    let timezone: String
    
    enum CodingKeys: String, CodingKey {
        case method = "_method"
        case startsAt = "starts_at"
        case questions = "booking_questions"
        
        case name
        case email
        case timezone
    }
    
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
