//
//  CreateAppointmentRequest.swift
//  barbr Watch App
//
//  Created by Marco Carmona on 2/14/23.
//

import Foundation

struct CreateAppointmentRequest {
    let method: String
    let name: String
    let email: String
    let startsAt: Date
    let questions: [AppointmentQuestion]
    let timezone: TimeZone
}
