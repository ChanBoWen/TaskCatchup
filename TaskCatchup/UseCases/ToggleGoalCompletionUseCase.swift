//
//  ToggleGoalCompletionUseCase.swift
//  TaskCatchup
//
//  Created by Bo Wen Chan on 10/9/2026.
//

import Foundation

/// **Business Rules:**
/// 1. Completing a goal awards the student the goal's reward points.
/// 2. If completing the goal finishes all goals for the day, the daily streak increases.
/// 3. Unticking a completed goal applies a mnus 20 points penalty to prevent cheating.
/// 4. Unticking a goal will also remove 1 day from the streak if it breaks a perfect day.
/// 5. A user cannot untick a goal if they do not have enough points to pay the penalty
///
struct ToggleGoalCompletionUseCase {
    let untickPenalty = 20
    
    func execute(goal: DailyGoal, profile: StudentProfile, allDailyGoals: [DailyGoal]) throws -> (updatedGoal: DailyGoal, updatedProfile: StudentProfile) {
        
        var updatedGoal = goal
        var updatedProfile = profile
        
        // Check if all goals for today are now completed
        let otherGoals = allDailyGoals.filter { $0.id != goal.id }
        let areAllOtherGoalsCompleted = otherGoals.allSatisfy { $0.isCompleted == true }
        
        // If the goal is not tick as completed yet
        if !goal.isCompleted {
            // Update the Goal
            updatedGoal.isCompleted = true
            
            // Add points
            updatedProfile.balancePoints += goal.rewardPoints
            
            if areAllOtherGoalsCompleted {
                // If every other goal was done, completing this one finishes the day
                updatedProfile.dailyStreak += 1
                
                // Check if a level is reached
                if updatedProfile.balancePoints >= (updatedProfile.currentLevel * 100) {
                    updatedProfile.currentLevel += 1
                }
            }
        // If it has already been ticked as completed
        } else {
            // Check whether enough points to decrease
            guard profile.balancePoints >= untickPenalty else {
                throw TaskCatchupError.cannotAffordPenalty(penalty: untickPenalty)
            }
            
            // Set the goal back to incomplete
            updatedGoal.isCompleted = false
            updatedProfile.balancePoints -= untickPenalty
            
            // Set the streak back
            if areAllOtherGoalsCompleted {
                updatedProfile.dailyStreak = max(0, updatedProfile.dailyStreak - 1)
            }
        }
        
        return (updatedGoal, updatedProfile)
    }
}
