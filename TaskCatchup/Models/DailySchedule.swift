//
//  DailySchedule.swift
//  TaskCatchup
//
//  Created by Bo Wen Chan on 10/9/2026.
//

import Foundation

/// Represents a custom scheduled event set manually by the student on their daily timeline.
///
/// **Business Rules:**
/// 1. A manual schedule must have a specific start time and end time.
/// 2. It helps the system calculate how much "free time" the user has to complete their flexible goals.
/// 
struct DailySchedule: Identifiable, Equatable, Codable {
    let id: UUID
    var title: String
    var startTime: Date  // The exact date and time the scheduled event begins
    var endTime: Date  // The exact date and time the scheduled event concludes
    var category: ScheduleCategory
    
    enum ScheduleCategory: String, CaseIterable, Codable {
        case academic = "Academic"
        case work = "Work"
        case sport = "Sport"
        case social = "Social"
        case rest = "Rest"
        
    }
    
    // Initialiser with default values
    init(id: UUID = UUID(), title: String, startTime: Date, endTime: Date, category: ScheduleCategory) {
        self.id = id
        self.title = title
        self.startTime = startTime
        self.endTime = endTime
        self.category = category
    }
}
