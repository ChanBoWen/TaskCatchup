//
//  DailyGoalsView.swift
//  TaskCatchup
//
//  Created by Bo Wen Chan on 10/9/2026.
//

import SwiftUI

/// Displays the student's  daily goals.
///
struct DailyGoalsView: View {
    @StateObject private var viewModel = DailyGoalsViewModel()
    
    var body: some View {
        VStack(spacing: 30) {
            // Top bar
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
                
                VStack(spacing: 10) {
                    Text("My Progress")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    // Current level
                    Text("Level \(viewModel.profile.currentLevel) ⭐️")
                        .font(.headline)
                        .foregroundColor(.orange)
                    
                    // Level progress bar
                    ProgressView(value: Double(viewModel.profile.balancePoints % 100), total: 100)
                        .tint(.orange)
                        .scaleEffect(x: 1.0, y: 1.5, anchor: .center)
                        .padding(.top, 4)
                        .padding(.horizontal, 40)
                }
            }
            .padding(.top)
            .padding(.horizontal)

            Spacer()
            
            // Header
            Text("My Today's Goals")
                .font(.title)
                .fontWeight(.bold)
            
            // Daily goals list
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(viewModel.todayGoals) { goal in
                        HStack {
                            // Checkbox button
                            Button(action: {
                                viewModel.toggleGoal(goal)
                            }) {
                                Image(systemName: goal.isCompleted ? "checkmark.square.fill" : "square")
                                    .foregroundColor(goal.isCompleted ? .green : .gray)
                                    .font(.title2)
                            }
                            
                            // Goal title
                            Text(goal.title)
                                // Strikethrough if tick completed
                                .strikethrough(goal.isCompleted, color: .gray)
                                .font(.headline)
                                .foregroundColor(goal.isCompleted ? .gray : .primary)
                            
                            Spacer()
                            
                            // Reward points
                            Text("+\(goal.rewardPoints) points")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .overlay(
                                    Rectangle()
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                                .foregroundColor(goal.isCompleted ? .gray : .primary)
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        // Shows domain errors
        .alert(isPresented: $viewModel.showError) {
            Alert(
                title: Text("Whoops!"),
                message: Text(viewModel.errorMessage ?? "An unknown error occurred!"),
                dismissButton: .default(Text("Got it"))
            )
        }
    }
}

#Preview {
    DailyGoalsView()
}
