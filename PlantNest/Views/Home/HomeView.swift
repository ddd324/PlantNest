//
//  Home.swift
//  PlantNest
//
//  Created by Djy on 01/09/2026.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject private var plantViewModel = PlantViewModel()
    @StateObject private var careViewModel = CareViewModel()
    
    var body: some View {
        List {
            Section("Today's Care") {
                if careViewModel.dueToday.isEmpty {
                    Text("No watering tasks today")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(careViewModel.dueToday) { plant in
                        NavigationLink {
                            WateringCheckView(plant: plant)
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(plant.name)
                                    .font(.headline)
                                
                                Text("Watering check due")
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
                                    Text("Water tomorrow")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                } else {
                                    Text("Water in \(item.daysRemaining) days")
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
            
            careViewModel.generateCarePlan(for: plantViewModel.plants)
        }
    }
}

#Preview {
    NavigationStack{
        HomeView()
    }
}
