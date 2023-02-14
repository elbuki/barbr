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
    @EnvironmentObject var userPreferences: UserPreferences

    @State var presentOnboarding = false
    
    var body: some View {
        VStack {
            Text("Data was added")
            // Date time selector
        }
        .onAppear(perform: viewDidLoad)
        .sheet(isPresented: $presentOnboarding, content: onboardingSheet)
        .padding()
    }
    
    private func viewDidLoad() {
        presentOnboarding = !userPreferences.isInitialized
    }
    
    private func onboardingSheet() -> some View {
        return OnboardingView(onDismiss: submitOnboarding)
            .toolbar(.hidden)
    }
    
    private func submitOnboarding(name: String, email: String, phone: Int) {
        userPreferences.name = name
        userPreferences.email = email
        userPreferences.phone = phone
        
        presentOnboarding = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserPreferences())
    }
}
