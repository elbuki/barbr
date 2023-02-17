//
//  BookAppointmentView.swift
//  barbr Watch App
//
//  Created by Marco Carmona on 2/16/23.
//

import SwiftUI
import WatchDatePicker

struct BookAppointmentView: View {
    @State private var startDate: Date = .now
    
    var body: some View {
        VStack {
            DatePicker(
                "Book",
                selection: $startDate.onChange(dateChanged),
                showValueOnButton: false
            )
        }
    }
    
    private func dateChanged(to value: Date) {
        // Get nearest available date from the fetched availabilities
        // Ask the user for confirmation
        // Call the API
        print("Date changed!")
    }
}
