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
    
    var body: some View {
        VStack {
            if preferences.savedAppointment == nil {
                BookAppointmentView()
                    .environmentObject(preferences)
                
                Spacer()
                
                Button(
                    action: {
                        presentOnboarding = true
                    },
                    label: {
                        Image(systemName: "pencil")
                    }
                )
                .clipShape(Circle())
            } else {
                Text("Booked for: \(formattedDate(date: preferences.savedAppointment!.startsAt))")
                    .multilineTextAlignment(.center)
                
                Button(
                    action: {
                        // TODO: Show confirmation dialog
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
        .padding()
    }
    
    private func viewDidLoad() {
        presentOnboarding = !preferences.isUserInitialized
    }
    
    private func onboardingSheet() -> some View {
        return OnboardingView(onDismiss: submitOnboarding)
            .toolbar(.hidden)
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
