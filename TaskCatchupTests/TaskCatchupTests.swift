//
//  TaskCatchupTests.swift
//  TaskCatchupTests
//
//  Created by Bo Wen Chan on 10/9/2026.
//

import Testing
@testable import TaskCatchup
import Foundation

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
        
        // Starts with dummy goals
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
    
    // ScheduleNewEventUseCase Tests
    @Test func test_scheduleEvent_fails_whenTitleIsEmpty() {
        let useCase = ScheduleNewEventUseCase()
        
        // Try to schedule an event with just spaces
        let newEvent = DailySchedule(title: "   ", startTime: Date(), endTime: Date().addingTimeInterval(3600), category: .academic)
        
        // Assert that it throws the expected domain error
        #expect(throws: TaskCatchupError.emptyScheduleTitle) {
            try useCase.execute(newEvent: newEvent, existingSchedule: [])
        }
    }
    
    // ScheduleNewEventUseCase Tests
    @Test func test_scheduleEvent_fails_whenTimeConflicts() {
        let useCase = ScheduleNewEventUseCase()
        let baseTime = Date()
        
        // Existing event that has been set
        let existingEvent = DailySchedule(title: "Math Class", startTime: baseTime, endTime: baseTime.addingTimeInterval(3600), category: .academic)
        
        // Try to set an overlapping event
        let overlappingEvent = DailySchedule(title: "Work Shift", startTime: baseTime.addingTimeInterval(1800), endTime: baseTime.addingTimeInterval(5400), category: .work)
        
        // Assert that it throws the expected domain error
        #expect(throws: TaskCatchupError.scheduleConflict) {
            try useCase.execute(newEvent: overlappingEvent, existingSchedule: [existingEvent])
        }
    }
    
    // ScheduleNewEventUseCase to repository Tests
    @MainActor
    @Test func test_addsSchedule_toRepository() {
        // Use the mock repo
        let mockRepo = LocalScheduleRepository()
        
        // Starts with dummy scheduled events
        let initialCount = mockRepo.fetchSchedules().count
        
        let viewModel = DailySchedulesViewModel(repository: mockRepo)
        
        // Schedule a future event
        let futureStart = Date().addingTimeInterval(86400 * 10)
        let futureEnd = futureStart.addingTimeInterval(3600)
        
        // User set a new event
        viewModel.addEvent(title: "Future Exam", startTime: futureStart, endTime: futureEnd, category: .academic)
        
        #expect(viewModel.todaySchedule.count == initialCount + 1)
        
        let savedSchedules = mockRepo.fetchSchedules()
        #expect(savedSchedules.count == initialCount + 1)
        #expect(savedSchedules.contains(where: { $0.title == "Future Exam" }))
    }
}
