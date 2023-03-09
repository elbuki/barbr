//
//  BookAppointmentView.swift
//  barbr Watch App
//
//  Created by Marco Carmona on 2/16/23.
//

import SwiftUI
import WatchDatePicker

struct BookAppointmentView: View {
    @State private var startDate = Date.now
    @State private var isLoading = true
    @State private var showConfirmationDialog = false
    @State private var bookings: [Booking] = []
    
    var body: some View {
        VStack {
            if isLoading {
                LoadingView()
            } else {
                DatePicker(
                    "Book",
                    selection: $startDate.onChange(dateChanged),
                    showValueOnButton: false
                )
            }
        }
        .sheet(isPresented: $showConfirmationDialog) {
            VStack {
                Text("Do you want to book for \(formattedStartsAtDate())?")
                    .multilineTextAlignment(.center)
                
                Spacer()

                Button(action: bookAppointment, label: { Text("Confirm") })
            }
            .padding(.horizontal)
        }
        .onAppear {
            Task {
                bookings = await TidyCal.shared.getAvailableBookings()
                isLoading = false
            }
        }
    }
    
    private func dateChanged() {
        // Ask the user for confirmation
        showConfirmationDialog = true
    }
    
    private func formattedStartsAtDate() -> String {
        let selected = selectBookingDate()
        let dateFormat = Date.FormatStyle()
            .year(.defaultDigits)
            .month(.abbreviated)
            .day(.twoDigits)
            .hour(.defaultDigits(amPM: .abbreviated))
            .minute(.twoDigits)
            .weekday(.abbreviated)

        return selected.startsAt.formatted(dateFormat)
    }
    
    func selectBookingDate() -> Booking {
        var selectedBooking: Booking?
        
        for booking in bookings {
            guard booking.startsAt > startDate else {
                continue
            }
            
            selectedBooking = booking
            break
        }
        
        guard let selectedBooking else {
            fatalError("Could not find a valid booking")
        }
        
        return selectedBooking
    }
    
    private func bookAppointment() {
        let selected = selectBookingDate()
        
        isLoading = true
        showConfirmationDialog = false
        
        Task {
            _ = await TidyCal.shared.bookAppointment(startsAt: selected.startsAt)
            
            isLoading = false
        }
    }
}
