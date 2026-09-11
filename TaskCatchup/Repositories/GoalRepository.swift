//
//  GoalRepository.swift
//  TaskCatchup
//
//  Created by Bo Wen Chan on 11/9/2026.
//

import Foundation

/// A protocol defining the data access rules for Daily Goals.
///
protocol GoalRepository {
    func fetchGoals() -> [DailyGoal]
    func addGoal(_ goal: DailyGoal) throws
    func updateGoal(_ goal: DailyGoal) throws
    func deleteGoal(_ goal: DailyGoal) throws
}
