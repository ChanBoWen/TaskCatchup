//
//  LocalGoalRepository.swift
//  TaskCatchup
//
//  Created by Bo Wen Chan on 11/9/2026.
//

import Foundation

/// A mock repository for testing
class LocalGoalRepository: GoalRepository {
    private var goals: [DailyGoal] = [
        DailyGoal(title: "Complete Assignment 1", category: .academic, isRecurring: false, rewardPoints: 20),
        DailyGoal(title: "Study for Quiz", category: .academic, isRecurring: false, rewardPoints: 20),
        DailyGoal(title: "Sleep 8 hours", category: .rest, isRecurring: true, rewardPoints: 5),
        DailyGoal(title: "Exercise 1 hour", category: .sport, isRecurring: true, rewardPoints: 15)
    ]
    
    func fetchGoals() -> [DailyGoal] {
        return goals
    }
    
    func addGoal(_ goal: DailyGoal) throws {
        goals.append(goal)
    }
    
    func updateGoal(_ goal: DailyGoal) throws {
        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
            goals[index] = goal
        }
    }
    
    func deleteGoal(_ goal: DailyGoal) throws {
        goals.removeAll { $0.id == goal.id }
    }
}
