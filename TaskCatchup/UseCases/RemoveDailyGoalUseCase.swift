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
///
struct RemoveDailyGoalUseCase {
    let removePenalty = 20
    
    func execute(goal: DailyGoal, profile: StudentProfile, existingGoals: [DailyGoal]) throws -> (updatedGoals: [DailyGoal], updatedProfile: StudentProfile) {
        
        // // Check whether enough points to decrease
        guard profile.balancePoints >= removePenalty else {
            throw TaskCatchupError.cannotAffordPenalty(penalty: removePenalty)
        }
        
        // Apply the penalty
        var updatedProfile = profile
        updatedProfile.balancePoints -= removePenalty
        
        // Remove the goal from the list
        var updatedGoals = existingGoals
        updatedGoals.removeAll { $0.id == goal.id }
        
        return (updatedGoals, updatedProfile)
    }
}
