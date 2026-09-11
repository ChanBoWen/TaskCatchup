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
    @Published var todaySchedule: [DailySchedule] = []
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    
    private let scheduleNewEventUseCase = ScheduleNewEventUseCase()
    
    let repository: ScheduleRepository
    
    init(repository: ScheduleRepository = JSONScheduleRepository()) {
        self.repository = repository
        
        // Profile dummy data for now
        self.profile = StudentProfile(name: "Alex", balancePoints: 40, lifetimeXP: 80, currentLevel: 1, dailyStreak: 2)
        
        load()
    }
    
    // Load the events from the JSON hard drive file
    func load() {
        self.todaySchedule = repository.fetchSchedules()
    }

    // Adds a new event to the schedule
    func addEvent(title: String, startTime: Date, endTime: Date, category: DailySchedule.ScheduleCategory) {
        let newEvent = DailySchedule(title: title, startTime: startTime, endTime: endTime, category: category)
        
        do {
            // Check for empty titles and double bookings
            let updatedSchedule = try scheduleNewEventUseCase.execute(newEvent: newEvent, existingSchedule: todaySchedule)
            
            
            // Save the newest event to the database
            if let addedEvent = updatedSchedule.first(where: { $0.id == newEvent.id }) {
                try? repository.addSchedule(addedEvent)
            }
            
            // Reload from the database
            load()
            
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
        // Delete from the database
        try? repository.deleteSchedule(event)
        
        // Reload from the database
        load()
    }
}
