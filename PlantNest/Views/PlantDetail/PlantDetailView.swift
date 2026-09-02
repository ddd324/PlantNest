//
//  PlantDetailView.swift
//  PlantNest
//
//  Created by Djy on 01/09/2026.
//

import SwiftUI

struct PlantDetailView: View {
    let plant: Plant
    
    var body: some View {
        List {
            Section {
                Image(plant.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .frame(height: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            
            Section("Plant Information") {
                LabeledContent("Name", value: plant.name)
                LabeledContent("Species", value: plant.species)
            }
            
            Section("Care") {
                LabeledContent("Watering interval", value: "\(plant.wateringIntervalDays) days")
                LabeledContent("Last watered", value: plant.lastWateredDate.formatted(date: .abbreviated, time: .omitted))
            }
            
            Section("History") {
                NavigationLink {
                    CareHistoryView(plant: plant)
                } label: {
                    Label("Care History", systemImage: "clock.arrow.circlepath")
                }
            }
        }
        .navigationTitle(plant.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        PlantDetailView(plant: Plant(
            name: "Monty",
            species: "Monstera deliciosa",
            imageName: "monstera",
            lastWateredDate: Date(),
            wateringIntervalDays: 7
        ))
    }
    .environmentObject(LocalCareRepository())
}
