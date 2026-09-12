//
//  SettingsView.swift
//  TaskCatchup
//
//  Created by Bo Wen Chan on 12/9/2026.
//

import SwiftUI

///
/// Further implementation will be In Assignment 3.
///
struct SettingsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "gearshape.fill")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("Settings")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Spacer()
            
            Text("Coming Soon!")
                .font(.largeTitle)
                .foregroundColor(.blue)
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
