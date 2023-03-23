//
//  OnboardingView.swift
//  barbr Watch App
//
//  Created by Marco Carmona on 2/13/23.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var name: String
    @Binding var email: String
    @Binding var phone: Int
    
    let onDismiss: ((String, String, Int) -> Void)?
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        return formatter
    }()
    
    var body: some View {
        VStack {
            TextField("Name", text: $name)
                .textInputAutocapitalization(.words)

            TextField("Email", text: $email)
                .textInputAutocapitalization(.never)

            TextField("Phone", value: $phone, formatter: formatter)
            
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
        OnboardingView(
            name: .constant(""),
            email: .constant(""),
            phone: .constant(0),
            onDismiss: nil
        )
    }
}
