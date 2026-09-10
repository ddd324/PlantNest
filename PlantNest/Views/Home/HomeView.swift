//
//  Home.swift
//  PlantNest
//
//  Created by Djy on 01/09/2026.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var plantViewModel: PlantViewModel
    @StateObject private var careViewModel = CareViewModel()
    
    var body: some View {
        List {
            Section("Today's Care") {
                if careViewModel.dueToday.isEmpty {
                    Text("No care tasks today")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(careViewModel.dueToday) { item in
                        NavigationLink {
                            if item.activityType == .watering {
                                WateringCheckView(plant: item.plant)
                            } else if item.activityType == .fertilising {
                                AddCareRecordView(plant: item.plant, initialActivity: .fertilising)
                            } else {
                                PlantDetailView(plant: item.plant)
                            }
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.plant.name)
                                    .font(.headline)
                                
                                Text("\(item.activityType.rawValue) due")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            
            Section("Upcoming Care") {
                if careViewModel.upcoming.isEmpty {
                    Text("No upcoming care tasks")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(careViewModel.upcoming) { item in
                        NavigationLink {
                            PlantDetailView(plant: item.plant)
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.plant.name)
                                    .font(.headline)
                                
                                if item.daysRemaining == 1 {
                                    Text("\(item.activityType.rawValue) tomorrow")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                } else {
                                    Text("\(item.activityType.rawValue) in \(item.daysRemaining) days")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Home")
        .onAppear {
            plantViewModel.loadPlants()
            careViewModel.generateCareSchedule(for: plantViewModel.plants)
        }
        .onChange(of: plantViewModel.plants) { _, newPlants in
            careViewModel.generateCareSchedule(for: newPlants)
            
        }
    }
}

#Preview {
    NavigationStack{
        HomeView()
    }
    .environmentObject(PlantViewModel())
    .environmentObject(LocalCareRepository())
}
