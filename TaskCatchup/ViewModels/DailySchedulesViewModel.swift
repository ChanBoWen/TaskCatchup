//
//  DailySchedulesViewModel.swift
//  TaskCatchup
//
//  Created by Bo Wen Chan on 11/9/2026.
//

import Foundation
import Combine

/// ViewModel responsible for managing the state and business logic for the Daily Schedules screen.
///
class DailySchedulesViewModel: ObservableObject {
    @Published var profile: StudentProfile
    @Published var todaySchedule: [DailySchedule]
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    
    private let scheduleNewEventUseCase = ScheduleNewEventUseCase()
    
    init() {
        // Dummy data for testing for now
        self.profile = StudentProfile(name: "Alex", balancePoints: 40, lifetimeXP: 80, currentLevel: 1, dailyStreak: 2)
        
        self.todaySchedule = [
            DailySchedule(title: "Biology Lecture", startTime: Date().addingTimeInterval(-3600), endTime: Date(), category: .academic),
            DailySchedule(title: "Cafe Shift", startTime: Date().addingTimeInterval(7200), endTime: Date().addingTimeInterval(14400), category: .work)
        ]
    }

    // Adds a new event to the schedule
    func addEvent(title: String, startTime: Date, endTime: Date, category: DailySchedule.ScheduleCategory) {
        let newEvent = DailySchedule(title: title, startTime: startTime, endTime: endTime, category: category)
        
        do {
            // Check for empty titles and double bookings
            let updatedSchedule = try scheduleNewEventUseCase.execute(newEvent: newEvent, existingSchedule: todaySchedule)
            self.todaySchedule = updatedSchedule
        } catch let error as TaskCatchupError {
            self.errorMessage = error.localizedDescription
            self.showError = true
        } catch {
            self.errorMessage = "An unexpected error occurred."
            self.showError = true
        }
    }
    
    // Removes a scheduled event
    func removeEvent(_ event: DailySchedule) {
        todaySchedule.removeAll { $0.id == event.id }
    }
}
