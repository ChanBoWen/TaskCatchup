//
//  TopBarView.swift
//  TaskCatchup
//
//  Created by Bo Wen Chan on 11/9/2026.
//

import SwiftUI

/// A reusable header component displayed across multiple tabs.
/// Shows the app title, profile picture, and the student's progress.
///
struct TopBarView: View {
    let profile: StudentProfile
    
    var body: some View {
        VStack(spacing: 20) {
            // App's title
            HStack {
                Spacer()
                Text("TaskCatchup")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Spacer()
            }
            // Profile picture
            .overlay(
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .frame(width: 45, height: 45)
                    .foregroundColor(.blue),
                alignment: .trailing
            )
            
            // Progress Section
            VStack(spacing: 10) {
                Text("My Progress")
                    .font(.title2)
                    .fontWeight(.bold)
                
                // Current level
                Text("Level \(profile.currentLevel) ⭐️")
                    .font(.headline)
                    .foregroundColor(.orange)
                
                // Level progress bar
                ProgressView(value: Double(profile.lifetimeXP % 100), total: 100)
                    .tint(.orange)
                    .scaleEffect(x: 1.0, y: 1.5, anchor: .center)
                    .padding(.top, 4)
                    .padding(.horizontal, 40)
            }
        }
        .padding(.top)
        .padding(.horizontal)
    }
}
