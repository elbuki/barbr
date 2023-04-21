//
//  MockClient.swift
//  barbr Watch App
//
//  Created by Marco Carmona on 2/8/23.
//

import Foundation

struct MockClient: Requester {
    
    let calendar = Calendar.current
    let amountOfHours = 10
    let delaySeconds = 2.0

    func getAvailableBookings() async -> [Booking] {
        var result: [Booking] = []
        
        await simulateDelay()

        guard let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date.now) else {
            fatalError("could not get the date for tomorrow")
        }

        guard let normalizedTime = calendar.date(bySetting: .minute, value: 0, of: tomorrow) else {
            fatalError("could not get normalized date for tomorrow's date")
        }

        for n in 1...amountOfHours {
            var booking: Booking

            guard let startDate = calendar.date(byAdding: .hour, value: n, to: normalizedTime) else {
                continue
            }

            guard let endDate = calendar.date(byAdding: .minute, value: 45, to: startDate) else {
                continue
            }

            booking = Booking(startsAt: startDate, endsAt: endDate, availableBookings: 1)

            result.append(booking)
        }
        
        return result
    }
    
    func bookAppointment(userData _: Preferences, startsAt timestamp: Date) async -> Appointment {
        guard let normalizedTime = calendar.date(bySetting: .minute, value: 0, of: timestamp) else {
            fatalError("could not get normalized date for tomorrow's date")
        }
        
        guard let endDate = calendar.date(byAdding: .minute, value: 45, to: normalizedTime) else {
            fatalError("could not get an end date for an appointment")
        }
        
        await simulateDelay()
        
        return .init(id: 1, slug: "test-slug", startsAt: timestamp, endsAt: endDate)
    }
    
    func cancelAppointment(slug _: String) async {
        await simulateDelay()
    }
    
    private func simulateDelay() async {
        _ = try? await Task.sleep(for: .seconds(delaySeconds))
    }

}
