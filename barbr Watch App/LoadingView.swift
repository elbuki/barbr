//
//  LoadingView.swift
//  barbr Watch App
//
//  Created by Marco Carmona on 2/16/23.
//

import SwiftUI

struct LoadingView: View {
    var labelText = "Loading"
    
    var body: some View {
        VStack {
            ProgressView()
                .scaleEffect(2)
            
            Text(labelText)
                .multilineTextAlignment(.center)
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
