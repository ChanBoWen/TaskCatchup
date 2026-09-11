//
//  TaskCatchupTests.swift
//  TaskCatchupTests
//
//  Created by Bo Wen Chan on 10/9/2026.
//

import Testing
@testable import TaskCatchup

struct TaskCatchupTests {
    
    // AddNewDailyGoalUseCase Tests
    @Test func test_addGoal_fails_whenTitleIsEmpty() {
        let useCase = AddNewDailyGoalUseCase()
        
        // Assert that it throws the expected domain error
        #expect(throws: TaskCatchupError.emptyGoalTitle) {
            try useCase.execute(title: "   ", category: .academic, isRecurring: false, existingGoals: [])
        }
    }
    
    // ToggleGoalCompletionUseCase Tests
    @Test func test_toggleGoal_succeeds_andAwardsPointsWhenGoalCompleted() throws {
        let useCase = ToggleGoalCompletionUseCase()
        
        // Sample data for testing
        let profile = StudentProfile(name: "Alex", balancePoints: 10, lifetimeXP: 20, currentLevel: 1, dailyStreak: 0)
        let goal = DailyGoal(title: "Read Book", category: .academic, isRecurring: false, rewardPoints: 20)
        
        let result = try useCase.execute(goal: goal, profile: profile, allDailyGoals: [goal])
        
        #expect(result.updatedGoal.isCompleted == true)
        #expect(result.updatedProfile.balancePoints == 30)  // Plus 20
        #expect(result.updatedProfile.lifetimeXP == 40)  // Plus 20
    }
    
    // ToggleGoalCompletionUseCase Tests
    @Test func test_toggleGoal_fails_whenUntickingWithInsufficientBP() {
        let useCase = ToggleGoalCompletionUseCase()
        
        // Sample data for testing
        // Set as completed, and 0 BP
        let profile = StudentProfile(name: "Alex", balancePoints: 0, lifetimeXP: 100, currentLevel: 2, dailyStreak: 1)
        var completedGoal = DailyGoal(title: "Read Book", category: .academic, isRecurring: false, rewardPoints: 20)
        completedGoal.isCompleted = true
        
        // Assert that it throws the expected domain error
        #expect(throws: TaskCatchupError.cannotAffordPenalty(penalty: 20)) {
            try useCase.execute(goal: completedGoal, profile: profile, allDailyGoals: [completedGoal])
        }
    }
    
    // RemoveDailyGoalUseCase Tests
    @Test func test_removeGoal_fails_whenBPIsTooLowToCoverPenalty() {
        let useCase = RemoveDailyGoalUseCase()
        
        // Sample data for testing
        // Set as 10 BP because less than the 20 BP penalty
        let profile = StudentProfile(name: "Alex", balancePoints: 10)
        let goal = DailyGoal(title: "Gym for 1 hour", category: .sport, isRecurring: true, rewardPoints: 15)
        
        // Assert that it throws the expected domain error
        #expect(throws: TaskCatchupError.cannotAffordPenalty(penalty: 20)) {
            try useCase.execute(goal: goal, profile: profile, existingGoals: [goal])
        }
    }
    
    // RemoveDailyGoalUseCase Tests
    @Test func test_removeGoal_succeeds_andDeductsPenaltyFromBalance() throws {
        let useCase = RemoveDailyGoalUseCase()
        
        // Sample data for testing
        let profile = StudentProfile(name: "Alex", balancePoints: 50)
        let goal = DailyGoal(title: "Gym", category: .sport, isRecurring: true, rewardPoints: 15)
        
        let result = try useCase.execute(goal: goal, profile: profile, existingGoals: [goal])
        
        #expect(result.updatedProfile.balancePoints == 30)  // Minus 20
        #expect(result.updatedGoals.isEmpty == true)  // Goal is removed from database
    }
    
    // AddNewDailyGoalUseCase to repository Tests
    @MainActor
    @Test func test_addsGoal_toRepository() {
        // Use the mock repo
        let mockRepo = LocalGoalRepository()
        
        // Starts with 4 dummy goals
        let initialGoalCount = mockRepo.fetchGoals().count
        
        let viewModel = DailyGoalsViewModel(repository: mockRepo)
        
        // User sets a new goal
        viewModel.addNewGoal(title: "Pass Assignment 2", category: .academic, isRecurring: false)
        
        #expect(viewModel.todayGoals.count == initialGoalCount + 1)
        #expect(viewModel.todayGoals.last?.title == "Pass Assignment 2")
        
        let savedGoals = mockRepo.fetchGoals()
        #expect(savedGoals.count == initialGoalCount + 1)
        #expect(savedGoals.last?.title == "Pass Assignment 2")
    }
}
