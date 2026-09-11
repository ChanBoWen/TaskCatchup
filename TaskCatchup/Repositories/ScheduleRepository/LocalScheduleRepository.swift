//
//  LocalScheduleRepository.swift
//  TaskCatchup
//
//  Created by Bo Wen Chan on 11/9/2026.
//

import Foundation

/// A mock repository for testing
///
class LocalScheduleRepository: ScheduleRepository {
    private var schedules: [DailySchedule] = [
        DailySchedule(title: "Biology Lecture", startTime: Date().addingTimeInterval(-3600), endTime: Date(), category: .academic),
        DailySchedule(title: "Cafe Shift", startTime: Date().addingTimeInterval(7200), endTime: Date().addingTimeInterval(14400), category: .work)
    ]
    
    func fetchSchedules() -> [DailySchedule] {
        return schedules
    }
    
    func addSchedule(_ schedule: DailySchedule) throws {
        schedules.append(schedule)
        schedules.sort { $0.startTime < $1.startTime }
    }
    
    func deleteSchedule(_ schedule: DailySchedule) throws {
        schedules.removeAll { $0.id == schedule.id }
    }
}
