//
//  Config.swift
//  barbr Watch App
//
//  Created by Marco Carmona on 4/20/23.
//

struct Config: Codable {
    let testMode: Bool
    let hashIdentifier: String
    let timeZone: String
    let questionID: Int
    let baseURL: String
}
