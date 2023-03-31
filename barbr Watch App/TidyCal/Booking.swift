//
//  Booking.swift
//  barbr Watch App
//
//  Created by Marco Carmona on 2/8/23.
//

import Foundation

struct Booking: Decodable, Identifiable {
    let startsAt: Date
    let endsAt: Date
    let availableBookings: Int
    
    var id: String {
        return startsAt.formatted(.iso8601)
    }
}
