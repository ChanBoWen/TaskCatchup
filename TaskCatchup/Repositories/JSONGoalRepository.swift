//
//  JSONGoalRepository.swift
//  TaskCatchup
//
//  Created by Bo Wen Chan on 11/9/2026.
//

import Foundation

/// A repository that saves and loads Daily Goals using a JSON file.
/// This ensures data persistence across app launches.
///
class JSONGoalRepository: GoalRepository {
    private(set) var goals: [DailyGoal] = []
    private let fileURL: URL
    
    init() {
        let fileManager = FileManager.default
        
        // Find the secure Documents folder on the iPhone
        let documentsURL = fileManager.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]
        
        fileURL = documentsURL.appendingPathComponent("SampleGoals.json")
        
        // Copy the bundled JSON to documents the first time
        if !fileManager.fileExists(atPath: fileURL.path) {
            if let bundledURL = Bundle.main.url(
                forResource: "SampleGoals",
                withExtension: "json"
            ) {
                try? fileManager.copyItem(
                    at: bundledURL,
                    to: fileURL
                )
            }
        }
        
        // Load the goals from the hard drive into memory
        goals = fetchGoals()
    }
    
    func fetchGoals() -> [DailyGoal] {
        do {
            let data = try Data(contentsOf: fileURL)
            return try JSONDecoder().decode([DailyGoal].self, from: data)
        } catch {
            print("Failed to load goals: \(error)")
            return []
        }
    }
    
    func addGoal(_ goal: DailyGoal) throws {
        goals.append(goal)
        save()
    }
    
    func updateGoal(_ goal: DailyGoal) throws {
        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
            goals[index] = goal
            save()
        }
    }
    
    func deleteGoal(_ goal: DailyGoal) throws {
        goals.removeAll { $0.id == goal.id }
        save()
    }
    
    // Translates the Swift objects back into JSON text and saves it to the hard drive
    private func save() {
        do {
            let data = try JSONEncoder().encode(goals)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            print("Failed to save goals: \(error)")
        }
    }
}
