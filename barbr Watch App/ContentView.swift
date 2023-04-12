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
    @State var cancelButtonDisabled = false
    
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
                .disabled(cancelButtonDisabled)
            }
        }
        .onAppear(perform: viewDidLoad)
        .sheet(isPresented: $presentOnboarding, content: onboardingSheet)
        .sheet(isPresented: $presentCancelConfirmation, content: cancelSheet)
        .padding()
    }
    
    private func viewDidLoad() {
        presentOnboarding = !preferences.isUserInitialized
        cancelButtonDisabled = true
        
        Task {
            guard let endsAt = preferences.savedAppointment?.endsAt else {
                return
            }
            
            if endsAt > Date.now {
                cancelButtonDisabled = false
                return
            }
            
            preferences.savedAppointment = nil
            
            await simulateDelay()
            
            cancelButtonDisabled = false
        }
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
                    
                    presentCancelConfirmation = false
                    cancelButtonDisabled = true
                    preferences.savedAppointment = nil
                    
                    await simulateDelay()
                    
                    cancelButtonDisabled = false
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
    
    private func simulateDelay() async {
        guard let _ = try? await Task.sleep(for: .seconds(2)) else {
            fatalError("could not simulate delay")
        }
    }
}
