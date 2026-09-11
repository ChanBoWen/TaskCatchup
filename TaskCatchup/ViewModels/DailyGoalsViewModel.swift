//
//  DailyGoalsViewModel.swift
//  TaskCatchup
//
//  Created by Bo Wen Chan on 10/9/2026.
//

import Foundation
import Combine

/// ViewModel responsible for managing the state and business logic of the Daily Goals screen.
///
class DailyGoalsViewModel: ObservableObject {
    @Published var profile: StudentProfile
    @Published var todayGoals: [DailyGoal]
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    
    private let toggleGoalUseCase = ToggleGoalCompletionUseCase()
    
    init() {
        // Dummy data for testing for now
        self.profile = StudentProfile(name: "Alex", balancePoints: 40, currentLevel: 1, dailyStreak: 2)
        
        self.todayGoals = [
            DailyGoal(title: "Complete Assignment 1", category: .academic, isRecurring: false, rewardPoints: 20),
            DailyGoal(title: "Study for Quiz", category: .academic, isRecurring: false, rewardPoints: 20),
            DailyGoal(title: "Sleep 8 hours", category: .rest, isRecurring: true, rewardPoints: 10),
            DailyGoal(title: "Exercise 1 hour", category: .sport, isRecurring: true, rewardPoints: 10)
        ]
    }
    
    // Toggles the completion status of a goal and updates the student's profile
    func toggleGoal(_ goal: DailyGoal) {
        do {
            // Execute the business rules
            let result = try toggleGoalUseCase.execute(goal: goal, profile: profile, allDailyGoals: todayGoals)
            
            // Update the profile
            self.profile = result.updatedProfile
            
            // Update the goal
            if let index = todayGoals.firstIndex(where: { $0.id == goal.id }) {
                todayGoals[index] = result.updatedGoal
            }
        } catch let error as TaskCatchupError {
            // Show error if cannot afford penalty
            self.errorMessage = error.localizedDescription
            self.showError = true
        } catch {
            self.errorMessage = "An unexpected error occurred."
            self.showError = true
        }
    }
}
