//
//  Booking.swift
//  barbr Watch App
//
//  Created by Marco Carmona on 2/8/23.
//

import Foundation

struct Booking {
    let startsAt: Date
    let endsAt: Date
    let availableBookings: Int
    
    static func decoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return decoder
    }
}
