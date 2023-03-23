//
//  ConfirmationView.swift
//  barbr Watch App
//
//  Created by Marco Carmona on 2/13/23.
//

import SwiftUI

struct ConfirmationView: View {
    let description: String
    let ctaText: String
    
    let onCancel: (() -> Void)
    let onSubmit: (() -> Void)
    
    var body: some View {
        VStack {
            Text(description)
                .multilineTextAlignment(.center)
            
            Button(
                action: onSubmit,
                label: { Text(ctaText) }
            )
        }
        .padding()
    }
}

struct ConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmationView(
            description: "Want to do something?",
            ctaText: "Yes",
            onCancel: {},
            onSubmit: {}
        )
    }
}
