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
//        {"_method":"post","name":"Marco Carmona","email":"mcarmonat@icloud.com","starts_at":"2023-02-15T21:30:00.000Z","booking_questions":[{"booking_type_question_id":251380,"answer":"87718365"}],"timezone":"America/Costa_Rica","payment_id":null}
        
        return .init(id: 0, startsAt: .now, endsAt: .now)
    }

}
