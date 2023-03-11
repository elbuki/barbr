//
//  Client.swift
//  barbr Watch App
//
//  Created by Marco Carmona on 2/8/23.
//

import Foundation

struct Client: Requester {
    
    private let dayLimit = 7
    private var baseURL: String
    private var identifier: String
    
    init() {
        guard let baseURL = ProcessInfo.processInfo.environment["tidycal_base_url"] else {
            fatalError("could not parse the base url")
        }

        guard let identifier = ProcessInfo.processInfo.environment["tidycal_hash"] else {
            fatalError("could not parse the hash")
        }
        
        self.baseURL = baseURL
        self.identifier = identifier
    }

    func getAvailableBookings() async -> [Booking] {
        let calendar = Calendar.current
        let start = Date.now
        let urlPortions = [
            baseURL,
            "booking-types",
            identifier,
            "available-bookings"
        ]
        var request: URLRequest

        guard let endDate = calendar.date(byAdding: .day, value: dayLimit, to: start) else {
            fatalError("could not get an end date for looking the availabilities")
        }
        
        guard var url = URL(string: urlPortions.joined(separator: "/")) else {
            fatalError("could not build an url for ")
        }
        
        let queryItems = [
            URLQueryItem(name: "start", value: start.formatted(.iso8601)),
            URLQueryItem(name: "end", value: endDate.formatted(.iso8601)),
        ]
        
        url.append(queryItems: queryItems)
        
        request = URLRequest(url: url)
        request.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            return try Decoder.shared.decode([Booking].self, from: data)
        } catch {
            fatalError(
                "could not get a valid response from the server: \(error)"
            )
        }
    }
    
    func bookAppointment(startsAt timestamp: Date) -> Appointment {
        // TODO: Create implementation
//        {"_method":"post","name":"Marco Carmona","email":"mcarmonat@icloud.com","starts_at":"2023-02-15T21:30:00.000Z","booking_questions":[{"booking_type_question_id":251380,"answer":"87718365"}],"timezone":"America/Costa_Rica","payment_id":null}
        
        return .init(id: 0, startsAt: .now, endsAt: .now)
    }

}
