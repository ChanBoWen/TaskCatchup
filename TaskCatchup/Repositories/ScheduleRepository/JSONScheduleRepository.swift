//
//  JSONScheduleRepository.swift
//  TaskCatchup
//
//  Created by Bo Wen Chan on 11/9/2026.
//

import Foundation

/// A repository that saves and loads Daily Schedules using a JSON file.
/// This ensures data persistence across app launches.
/// 
class JSONScheduleRepository: ScheduleRepository {
    private(set) var schedules: [DailySchedule] = []
    private let fileURL: URL
    
    init() {
        let fileManager = FileManager.default
        
        // Find the secure Documents folder on the iPhone
        let documentsURL = fileManager.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]
        
        fileURL = documentsURL.appendingPathComponent("SampleSchedules.json")
        
        // Copy the bundled JSON to documents the first time
        if !fileManager.fileExists(atPath: fileURL.path) {
            if let bundledURL = Bundle.main.url(
                forResource: "SampleSchedules",
                withExtension: "json"
            ) {
                try? fileManager.copyItem(
                    at: bundledURL,
                    to: fileURL
                )
            }
        }
        
        // Load the events from the hard drive into memory
        schedules = fetchSchedules()
    }
    
    func fetchSchedules() -> [DailySchedule] {
        do {
            let data = try Data(contentsOf: fileURL)
            return try JSONDecoder().decode([DailySchedule].self, from: data)
        } catch {
            print("Failed to load schedules: \(error)")
            return []
        }
    }
    
    func addSchedule(_ schedule: DailySchedule) throws {
        schedules.append(schedule)
        schedules.sort { $0.startTime < $1.startTime }
        save()
    }
    
    func deleteSchedule(_ schedule: DailySchedule) throws {
        schedules.removeAll { $0.id == schedule.id }
        save()
    }
    
    // Translates the Swift objects back into JSON text and saves it to the hard drive
    private func save() {
        do {
            let data = try JSONEncoder().encode(schedules)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            print("Failed to save schedules: \(error)")
        }
    }
}
