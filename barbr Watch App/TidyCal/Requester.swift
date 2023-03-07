//
//  Requester.swift
//  barbr Watch App
//
//  Created by Marco Carmona on 2/8/23.
//

import Foundation

protocol Requester {
    func getAvailableBookings() async -> [Booking]
    func bookAppointment(startsAt: Date) async -> Appointment
}
