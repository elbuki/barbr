//
//  OnboardingView.swift
//  barbr Watch App
//
//  Created by Marco Carmona on 2/13/23.
//

import SwiftUI

struct OnboardingView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var phone = 0
    
    let onDismiss: ((String, String, Int) -> Void)?
    
    var body: some View {
        VStack {
            TextField("Name", text: $name)
            TextField("Email", text: $email)
            TextField("Phone", value: $phone, format: .number)
            
            Button(
                action: { onDismiss?(name, email, phone) },
                label: {
                    Text("Done")
                }
            )
            .disabled(!isFormValid())
        }
    }
    
    private func isFormValid() -> Bool {
        return name != "" && email != "" && phone != 0
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(onDismiss: nil)
    }
}
