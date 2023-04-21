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

    @State private var isLoading = true
    @State private var showConfirmationDialog = false
    @State private var showTimePicker = false
    @State private var bookings: [Booking] = []
    @State private var sectionedBooking: [SectionBooking] = []
    
    class SheetManager: ObservableObject {
        @Published var startDate = Date.now
    }
    
    @StateObject var sheetManager = SheetManager()
    
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
                Text("Do you want to book for \(formattedStartsAtDate())?")
                    .multilineTextAlignment(.center)

                Spacer()

                Button(action: bookAppointment, label: { Text("Confirm") })
            }
            .padding(.horizontal)
        }
        .sheet(isPresented: $showTimePicker) {
            ScrollView {
                LazyVStack(pinnedViews: .sectionHeaders) {
                    ForEach(sectionedBooking) { section in
                        Section(
                            content: {
                                ForEach(section.bookings) { booking in
                                    Button(
                                        action: {
                                            sheetManager.startDate = booking.startsAt
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

        return sheetManager.startDate.formatted(dateFormat)
    }
    
    private func bookAppointment() {
        isLoading = true
        showConfirmationDialog = false
        
        Task {
            let booked = await TidyCal.shared.bookAppointment(
                userData: preferences,
                startsAt: sheetManager.startDate
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
    
    private func formattedStartsAtTime(date: Date) -> String {
        let dateFormat = Date.FormatStyle()
            .hour(.defaultDigits(amPM: .abbreviated))
            .minute(.twoDigits)

        return date.formatted(dateFormat)
    }
}
