//
//  Booking.swift
//  barbr Watch App
//
//  Created by Marco Carmona on 2/8/23.
//

import Foundation

struct Booking: Codable {
    let startsAt: Date
    let endsAt: Date
    let availableBookings: Int
}
