//
//  ScheduleNewEventUseCase.swift
//  TaskCatchup
//
//  Created by Bo Wen Chan on 10/9/2026.
//

import Foundation

/// **Business Rules:**
/// 1. An event must have a valid title.
/// 2. An event cannot overlap with an existing scheduled event.
///
struct ScheduleNewEventUseCase {
    func execute(newEvent: DailySchedule, existingSchedule: [DailySchedule]) throws -> [DailySchedule] {
        // Validate title
        guard !newEvent.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw TaskCatchupError.emptyScheduleTitle
        }
        
        // Check for time conflicts
        let hasConflict = existingSchedule.contains { existingEvent in
            return newEvent.startTime < existingEvent.endTime && newEvent.endTime > existingEvent.startTime
        }
        
        guard !hasConflict else {
            throw TaskCatchupError.scheduleConflict
        }
        
        // Add the new event to the schedule
        var updatedSchedule = existingSchedule
        updatedSchedule.append(newEvent)
        
        // Sort the events in chronologically time
        updatedSchedule.sort { $0.startTime < $1.startTime }
        
        return updatedSchedule
    }
}
