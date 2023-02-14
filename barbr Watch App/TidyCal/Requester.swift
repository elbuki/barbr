//
//  Requester.swift
//  barbr Watch App
//
//  Created by Marco Carmona on 2/8/23.
//

import Foundation

protocol Requester {
    func getAvailableBookings() -> [Booking]
    func bookAppointment(startsAt: Date) -> Appointment
}
