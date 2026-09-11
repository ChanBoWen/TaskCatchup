//
//  RemoveDailyGoalUseCase.swift
//  TaskCatchup
//
//  Created by Bo Wen Chan on 11/9/2026.
//

import Foundation

/// **Business Rules:**
/// 1. Removing a goal incurs a 20 BP penalty to discourage abandoning tasks.
/// 2. A user cannot delete a goal if they do not have enough BP to pay the penalty.
/// 3. If a completed goal is removed, the claimed XP is reverted.
///
struct RemoveDailyGoalUseCase {
    let removePenalty = 20
    
    func execute(goal: DailyGoal, profile: StudentProfile, existingGoals: [DailyGoal]) throws -> (updatedGoals: [DailyGoal], updatedProfile: StudentProfile) {
        // Check whether enough points to decrease
        guard profile.balancePoints >= removePenalty else {
            throw TaskCatchupError.cannotAffordPenalty(penalty: removePenalty)
        }
        
        // Apply the penalty
        var updatedProfile = profile
        updatedProfile.balancePoints -= removePenalty
        
        // If the goal was already ticked as completed, revert the gained XP
        if goal.isCompleted {
            updatedProfile.lifetimeXP = max(0, updatedProfile.lifetimeXP - goal.rewardPoints)
        }
        
        // Dynamic level calculation
        updatedProfile.currentLevel = (updatedProfile.lifetimeXP / 100) + 1
        
        // Remove the goal from the list
        var updatedGoals = existingGoals
        updatedGoals.removeAll { $0.id == goal.id }
        
        return (updatedGoals, updatedProfile)
    }
}
