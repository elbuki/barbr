//
//  Client.swift
//  barbr Watch App
//
//  Created by Marco Carmona on 2/8/23.
//

import Foundation

struct Client: Requester {

    let baseURL: String
    let identifier: String
    let bookingTypeID: Int
    let timeZone: String
    
    init(config: Config) {
        self.baseURL = config.baseURL
        self.identifier = config.hashIdentifier
        self.bookingTypeID = config.questionID
        self.timeZone = config.timeZone
    }
    
    private let dayLimit = 7

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
            fatalError("could not build an url for getting available bookings")
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
    
    func bookAppointment(userData: Preferences, startsAt timestamp: Date) async -> Appointment {
        let urlPortions = [
            baseURL,
            "bookings",
            identifier,
        ]
        var request: URLRequest
        var requestBody: CreateAppointmentRequest
        
        guard let url = URL(string: urlPortions.joined(separator: "/")) else {
            fatalError("could not build an url for booking an appointment")
        }
        
        guard let name = userData.name else {
            fatalError("could not get name from the user")
        }
        
        guard let email = userData.email else {
            fatalError("could not get email from the user")
        }
        
        guard let phone = userData.phone else {
            fatalError("could not get phone from the user")
        }
        
        request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        request.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
        requestBody = .init(
            method: "post",
            name: name,
            email: email,
            startsAt: timestamp,
            questions: [
                .init(
                    bookingTypeQuestionID: bookingTypeID,
                    answer: String(phone)
                )
            ],
            timezone: timeZone
        )

        guard let data = try? requestBody.encodeToJSON() else {
            fatalError("could not encode the data to json")
        }
        
        request.httpMethod = "POST"
        request.httpBody = data
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            return try Decoder.shared.decode(Appointment.self, from: data)
        } catch {
            fatalError(
                "could not get a valid response from the server: \(error)"
            )
        }
    }
    
    func cancelAppointment(slug: String) async {
        let urlPortions = [
            baseURL,
            "booking-types",
            identifier,
            "bookings",
            slug,
            "cancel"
        ]
        var request: URLRequest
        
        guard let url = URL(string: urlPortions.joined(separator: "/")) else {
            fatalError("could not build an url for cancel an appointment")
        }
        
        request = URLRequest(url: url)

        request.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
        request.httpMethod = "POST"
        
        do {
            _ = try await URLSession.shared.data(for: request)
        } catch {
            fatalError(
                "could not get a valid response from the server: \(error)"
            )
        }
    }

}
