//
//  DailySchedulesView.swift
//  TaskCatchup
//
//  Created by Bo Wen Chan on 10/9/2026.
//

import SwiftUI

/// Displays the student's daily scheduled events
///
struct DailySchedulesView: View {
    @StateObject private var viewModel = DailySchedulesViewModel()
    
    @State private var showingAddEventForm = false
    
    var body: some View {
        VStack(spacing: 30) {
            // Top bar
            TopBarView(profile: viewModel.profile)
            
            Spacer()
            
            // Header
            HStack {
                Text("Today's Schedule")
                    .font(.title)
                    .fontWeight(.bold)
                
                Spacer()
                
                // Add new event button
                Button(action: {
                    showingAddEventForm = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                        .foregroundColor(.blue)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal)
            .padding(.bottom, 5)
            
            // Scheduled event list
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(viewModel.todaySchedule) { event in
                        HStack {
                            Text(event.startTime, style: .time)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            VStack(alignment: .leading) {
                                Text(event.title)
                                    .font(.headline)
                                Text(event.category.rawValue)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom, 20)
            }
        }
        // Shows domain errors
        .alert(isPresented: $viewModel.showError) {
            Alert(
                title: Text("Whoops!"),
                message: Text(viewModel.errorMessage ?? "An unknown error occurred!"),
                dismissButton: .default(Text("Got it"))
            )
        }
        
        // Opens the add event sheet
        .sheet(isPresented: $showingAddEventForm) {
            AddNewScheduleView(viewModel: viewModel, isPresented: $showingAddEventForm)
        }
    }
}

#Preview {
    DailySchedulesView()
}
