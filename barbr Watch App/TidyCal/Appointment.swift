//
//  Appointment.swift
//  barbr Watch App
//
//  Created by Marco Carmona on 2/14/23.
//

import Foundation

struct Appointment: Decodable {
    let id: Int
    let startsAt: Date
    let endsAt: Date
}
