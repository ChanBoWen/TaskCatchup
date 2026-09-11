//
//  ScheduleRepository.swift
//  TaskCatchup
//
//  Created by Bo Wen Chan on 11/9/2026.
//

import Foundation

/// A protocol defining the data access rules for Daily Schedules.
///
protocol ScheduleRepository {
    func fetchSchedules() -> [DailySchedule]
    func addSchedule(_ schedule: DailySchedule) throws
    func deleteSchedule(_ schedule: DailySchedule) throws
}
