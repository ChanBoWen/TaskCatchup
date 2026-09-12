//
//  ProfileView.swift
//  TaskCatchup
//
//  Created by Bo Wen Chan on 12/9/2026.
//

import SwiftUI

/// Displays comprehensive user details, stats, and unlocked features.
/// 
struct ProfileView: View {
    // Pass the profile from the Top Bar
    let profile: StudentProfile
    
    @Environment(\.dismiss) private var dismiss
    
    // Grid layout for the stats dashboard
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 30) {
                    // Profile picture
                    VStack(spacing: 20) {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.blue)
                        
                        // User name
                        Text(profile.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                    .padding(.bottom, 5)
                    
                    // Stats dashboard
                    LazyVGrid(columns: columns, spacing: 15) {
                        // Current level
                        StatCardView(icon: "star.fill", title: "Current Level", value: "\(profile.currentLevel)", color: .orange)
                        
                        // Daily streak
                        StatCardView(icon: "flame.fill", title: "Daily Streak", value: "\(profile.dailyStreak)", color: .red)
                        
                        // Total XP gained
                        StatCardView(icon: "sparkles", title: "Lifetime XP Gained", value: "\(profile.lifetimeXP)", color: .purple)
                        
                        // Total remaining BP
                        StatCardView(icon: "bitcoinsign.circle.fill", title: "Balance Points", value: "\(profile.balancePoints)", color: .yellow)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                    
                    // Show active vouchers
                    VStack(alignment: .leading, spacing: 10) {
                        // Header
                        Text("My Inventory")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        // List of every vouchers
                        ForEach(profile.activeVouchers, id: \.self) { voucher in
                            HStack {
                                Image(systemName: "ticket.fill")
                                    .foregroundColor(.blue)
                                
                                Text(voucher.rawValue)
                                    .fontWeight(.semibold)
                                
                                Spacer()
                            }
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(10)
                            .padding(.horizontal)
                        }
                    }
                    
                    Spacer()
                }
            }
            .toolbar {
                // Title
                ToolbarItem(placement: .principal) {
                    Text("My Profile")
                        .font(.title)
                        .fontWeight(.bold)
                        .offset(y: 30)
                }
                
                // Done button to return
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileView(profile: StudentProfile(name: "Alex", balancePoints: 120, lifetimeXP: 340, currentLevel: 4, dailyStreak: 7, activeVouchers: [.guiltFreeRest]))
}
