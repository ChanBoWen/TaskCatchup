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
    @Published var todayGoals: [DailyGoal] = []
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    
    private let toggleGoalUseCase = ToggleGoalCompletionUseCase()
    private let addGoalUseCase = AddNewDailyGoalUseCase()
    private let removeGoalUseCase = RemoveDailyGoalUseCase()
    
    let repository: GoalRepository
        
    init(repository: GoalRepository = JSONGoalRepository()) {
        self.repository = repository
        
        // Profile dummy data for now
        self.profile = StudentProfile(name: "Alex", balancePoints: 40, lifetimeXP: 80, currentLevel: 1, dailyStreak: 2)
        
        load()
    }
    
    // Load the goals from the JSON hard drive file
    func load() {
        self.todayGoals = repository.fetchGoals()
    }
    
    // Toggles the completion status of a goal and updates the student's profile
    func toggleGoal(_ goal: DailyGoal) {
        do {
            // Execute the business rules
            let result = try toggleGoalUseCase.execute(goal: goal, profile: profile, allDailyGoals: todayGoals)
            
            // Update the profile
            self.profile = result.updatedProfile
            
            // Update to the database
            try? repository.updateGoal(result.updatedGoal)
            
            // Reload from the database
            load()
            
        } catch let error as TaskCatchupError {
            // Show error if cannot afford penalty
            self.errorMessage = error.localizedDescription
            self.showError = true
        } catch {
            self.errorMessage = "An unexpected error occurred."
            self.showError = true
        }
    }
    
    // Adds a new goal to today's list
    func addNewGoal(title: String, category: DailyGoal.GoalCategory, isRecurring: Bool) {
        do {
            let updatedGoals = try addGoalUseCase.execute(
                title: title,
                category: category,
                isRecurring: isRecurring,
                existingGoals: todayGoals
            )
            
            // Save the newest goal to the database
            if let newestGoal = updatedGoals.last {
                try? repository.addGoal(newestGoal)
            }
            
            // Reload from the database
            load()
            
        } catch let error as TaskCatchupError {
            self.errorMessage = error.localizedDescription
            self.showError = true
        } catch {
            self.errorMessage = "An unexpected error occurred."
            self.showError = true
        }
    }
    
    // Removes a goal and applies the penalty
    func removeGoal(_ goal: DailyGoal) {
        do {
            let result = try removeGoalUseCase.execute(goal: goal, profile: profile, existingGoals: todayGoals)
            self.profile = result.updatedProfile
            
            // Delete from the database
            try? repository.deleteGoal(goal)
            
            // Reload from the database
            load()
            
            // Show error if cannot afford penalty
        } catch let error as TaskCatchupError {
            self.errorMessage = error.localizedDescription
            self.showError = true
        } catch {
            self.errorMessage = "An unexpected error occurred."
            self.showError = true
        }
    }
}
