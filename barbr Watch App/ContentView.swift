//
//  ContentView.swift
//  barbr Watch App
//
//  Created by Marco Carmona on 2/8/23.
//

import SwiftUI

// José Astúa: 36wew41
// Test: 19nkjdm

struct ContentView: View {
    @EnvironmentObject var preferences: Preferences
    
    @State var presentOnboarding = false
    @State var presentCancelConfirmation = false
    
    var body: some View {
        VStack {
            if preferences.savedAppointment == nil {
                BookAppointmentView(onEditPressed: { presentOnboarding = true })
                    .environmentObject(preferences)
            } else {
                Text("Booked for: \(formattedDate(date: preferences.savedAppointment!.startsAt))")
                    .multilineTextAlignment(.center)
                
                Button(
                    action: {
                        presentCancelConfirmation = true
                    },
                    label: {
                        Image(systemName: "xmark.circle.fill")
                    }
                )
                .clipShape(Circle())
            }
        }
        .onAppear(perform: viewDidLoad)
        .sheet(isPresented: $presentOnboarding, content: onboardingSheet)
        .sheet(isPresented: $presentCancelConfirmation, content: cancelSheet)
        .padding()
    }
    
    private func viewDidLoad() {
        presentOnboarding = !preferences.isUserInitialized
    }
    
    private func onboardingSheet() -> some View {
        return OnboardingView(
            name: $preferences.name,
            email: $preferences.email,
            phone: $preferences.phone,
            onDismiss: submitOnboarding
        )
        .toolbar(.hidden)
    }
    
    private func cancelSheet() -> some View {
        let dateDescription = preferences.savedAppointment?.startsAt.formatted() ?? ""
        
        guard let slug = preferences.savedAppointment?.slug else {
            fatalError("Could not get a slug from the appointment")
        }
        
        return ConfirmationView(
            description: "Cancel the appointment for \(dateDescription)?",
            ctaText: "Yes",
            onCancel: {
                presentCancelConfirmation = false
            },
            onSubmit: {
                Task {
                    await TidyCal.shared.cancelAppointment(slug: slug)
                    
                    preferences.savedAppointment = nil
                    presentCancelConfirmation = false
                }
            }
        )
    }
    
    private func submitOnboarding(name: String, email: String, phone: Int) {
        preferences.name = name
        preferences.email = email
        preferences.phone = phone
        
        presentOnboarding = false
    }
    
    private func formattedDate(date: Date) -> String {
        let dateFormat = Date.FormatStyle()
            .year(.defaultDigits)
            .month(.abbreviated)
            .day(.twoDigits)
            .hour(.defaultDigits(amPM: .abbreviated))
            .minute(.twoDigits)
            .weekday(.abbreviated)

        return date.formatted(dateFormat)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Preferences())
    }
}
