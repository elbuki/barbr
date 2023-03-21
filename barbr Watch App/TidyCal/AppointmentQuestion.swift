//
//  AppointmentQuestion.swift
//  barbr Watch App
//
//  Created by Marco Carmona on 2/14/23.
//

struct AppointmentQuestion: Encodable {
    let bookingTypeQuestionID: Int
    let answer: String
    
    enum CodingKeys: String, CodingKey {
        case bookingTypeQuestionID = "booking_type_question_id"

        case answer
    }
}
