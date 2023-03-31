//
//  BookAppointmentView.swift
//  barbr Watch App
//
//  Created by Marco Carmona on 2/16/23.
//

import SwiftUI

struct SectionBooking: Identifiable {
    let id = UUID()
    let date: String
    let bookings: [Booking]
}

struct BookAppointmentView: View {
    @EnvironmentObject var preferences: Preferences
    
    let onEditPressed: () -> Void
    
    @State private var startDate = Date.now
    @State private var isLoading = true
    @State private var showConfirmationDialog = false
    @State private var showTimePicker = false
    @State private var bookings: [Booking] = []
    @State private var sectionedBooking: [SectionBooking] = []
    
    var body: some View {
        VStack {
            if isLoading {
                LoadingView()
            } else {
                Button(
                    action: { showTimePicker = true },
                    label: { Text("Book") }
                )
                
                Spacer()
                
                Button(
                    action: onEditPressed,
                    label: { Image(systemName: "pencil") }
                )
                .clipShape(Circle())
            }
        }
        .sheet(isPresented: $showConfirmationDialog) {
            VStack {
                Text("Do you want to book for \(startDate)?")
                    .multilineTextAlignment(.center)
                
                Spacer()

                Button(action: bookAppointment, label: { Text("Confirm") })
            }
            .padding(.horizontal)
        }
        .sheet(isPresented: $showTimePicker) {
            BookingPicker(
                startDate: $startDate,
                showTimePicker: $showTimePicker,
                showConfirmationDialog: $showConfirmationDialog,
                sectionedBookings: sectionedBooking
            )
        }
        .onAppear {
            Task {
                bookings = await TidyCal.shared.getAvailableBookings()
                bookingToSectionedList()
                isLoading = false
            }
        }
    }

    private func formattedStartsAtDate() -> String {
        let dateFormat = Date.FormatStyle()
            .year(.defaultDigits)
            .month(.abbreviated)
            .day(.twoDigits)
            .hour(.defaultDigits(amPM: .abbreviated))
            .minute(.twoDigits)
            .weekday(.abbreviated)

        return startDate.formatted(dateFormat)
    }
    
    private func bookAppointment() {
        isLoading = true
        showConfirmationDialog = false
        
        Task {
            let booked = await TidyCal.shared.bookAppointment(
                userData: preferences,
                startsAt: startDate
            )
            
            preferences.savedAppointment = booked
            
            isLoading = false
        }
    }
    
    private func bookingToSectionedList() {
        let dateFormat = Date.FormatStyle()
            .year(.defaultDigits)
            .month(.abbreviated)
            .day(.twoDigits)
        
        var dates: [String: [Booking]] = [:]
        var sections: [SectionBooking] = []
        
        for booking in bookings {
            let formattedDate = booking.startsAt.formatted(dateFormat)

            if dates[formattedDate] == nil {
                dates[formattedDate] = [booking]
                continue
            }
            
            dates[formattedDate]?.append(booking)
        }
        
        for (key, value) in dates {
            let newElement = SectionBooking(date: key, bookings: value)
            
            sections.append(newElement)
        }
        
        sections.sort { $0.bookings[0].startsAt < $1.bookings[0].endsAt }
        
        sectionedBooking = sections
    }
}

struct BookingPicker: View {
    @Binding var startDate: Date
    @Binding var showTimePicker: Bool
    @Binding var showConfirmationDialog: Bool
    
    let sectionedBookings: [SectionBooking]
    
    var body: some View {
        ScrollView {
            LazyVStack(pinnedViews: .sectionHeaders) {
                ForEach(sectionedBookings) { section in
                    Section(
                        content: {
                            ForEach(section.bookings) { booking in
                                Button(
                                    action: {
                                        startDate = booking.startsAt
                                        showTimePicker = false
                                        showConfirmationDialog = true
                                    },
                                    label: {
                                        Text(formattedStartsAtTime(date: booking.startsAt))
                                    }
                                )
                            }
                            .padding(.horizontal)
                        },
                        header: {
                            ZStack {
                                Color.gray
                                
                                Text(section.date)
                            }
                        }
                    )
                }
            }
        }
    }
    
    private func formattedStartsAtTime(date: Date) -> String {
        let dateFormat = Date.FormatStyle()
            .hour(.defaultDigits(amPM: .abbreviated))
            .minute(.twoDigits)

        return date.formatted(dateFormat)
    }
}
