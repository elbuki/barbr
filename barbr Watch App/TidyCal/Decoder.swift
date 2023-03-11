//
//  Decoder.swift
//  barbr Watch App
//
//  Created by Marco Carmona on 3/11/23.
//

import Foundation

struct Decoder {
    static let shared = Decoder()

    private var jsonDecoder: JSONDecoder
    
    init() {
        let decoder = JSONDecoder()
        
        decoder.dateDecodingStrategy = .custom { decoder -> Date in
            let formatter = ISO8601DateFormatter()
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            formatter.formatOptions = [
                .withInternetDateTime,
                .withFractionalSeconds,
            ]
            
            guard let date = formatter.date(from: dateString) else {
                throw DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "Cannot decode date string \(dateString)"
                )
            }
            
            return date
        }

        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        jsonDecoder = decoder
    }
    
    func decode<T>(
        _ type: T.Type,
        from data: Data
    ) throws -> T where T : Decodable {

        return try jsonDecoder.decode(type, from: data)

    }
}
