//
//  StudentProfile.swift
//  TaskCatchup
//
//  Created by Bo Wen Chan on 10/9/2026.
//

import Foundation

/// Represents the student's current wellbeing metrics, progress, and available rewards.
///
/// **Business Rules:**
/// 1. Balance Points (BP) are used as currency and cannot drop below zero.
/// 2. Level represents lifetime progression and never decreases.
/// 3. Daily Streak resets if the student goes a full day without completing a goal
///
struct StudentProfile: Equatable {
    let id: UUID
    var name: String
    var balancePoints: Int
    var currentLevel: Int
    var dailyStreak: Int  // The number of consecutive days the student has completed all their set goals
    var activeVouchers: [VoucherType]  // How much active boost cards or vouchers the student has
    
    enum VoucherType: String, Equatable {
        case guiltFreeRest = "Guilt-Free Rest Day"
        case doubleXP = "Double BP Boost"
    }
    
    // Initialiser with default values
    init(id: UUID = UUID(), name: String, balancePoints: Int = 0, currentLevel: Int = 1, dailyStreak: Int = 0, activeVouchers: [VoucherType] = []) {
        self.id = id
        self.name = name
        self.balancePoints = balancePoints
        self.currentLevel = currentLevel
        self.dailyStreak = dailyStreak
        self.activeVouchers = activeVouchers
    }
}
