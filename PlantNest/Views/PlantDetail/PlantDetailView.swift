//
//  PlantDetailView.swift
//  PlantNest
//
//  Created by Djy on 01/09/2026.
//

import SwiftUI

struct PlantDetailView: View {
    let plant: Plant
    
    private var nextWateringDate: Date? {
        Calendar.current.date(
            byAdding: .day,
            value: plant.wateringIntervalDays,
            to: plant.lastWateredDate
        )
    }
    
    private var nextFertilisingDate: Date? {
        guard let lastFertilisedDate = plant.lastFertilisedDate,
              let fertilisingIntervalDays = plant.fertilisingIntervalDays
        else {
            return nil
        }

        return Calendar.current.date(
            byAdding: .day,
            value: fertilisingIntervalDays,
            to: lastFertilisedDate
        )
    }
    
    var body: some View {
        List {
            Section {
                if let imageData = plant.imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .frame(height: 220)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                } else if !plant.imageName.isEmpty {
                    Image(plant.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .frame(height: 220)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                } else {
                    Image(systemName: "leaf.fill")
                        .resizable()
                        .scaledToFit()
                        .padding(60)
                        .frame(maxWidth: .infinity)
                        .frame(height: 220)
                        .background(.quaternary)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
            
            Section("Plant Information") {
                LabeledContent("Name", value: plant.name)
                LabeledContent("Species", value: plant.species)
            }
            
            Section("Care") {
                LabeledContent("Watering", value: "Every \(plant.wateringIntervalDays) days")
                
                LabeledContent("Last watered", value: plant.lastWateredDate.formatted(date: .abbreviated, time: .omitted))
                
                if let nextWateringDate {
                    LabeledContent(
                        "Next watering check",
                        value: nextWateringDate.formatted(
                            date: .abbreviated,
                            time: .omitted
                        )
                    )
                }
                
                if let fertilisingIntervalDays = plant.fertilisingIntervalDays {
                    LabeledContent("Fertilising", value: "Every \(fertilisingIntervalDays) days")
                }
                
                if let lastFertilisedDate = plant.lastFertilisedDate {
                    LabeledContent("Last fertilised", value: lastFertilisedDate.formatted(date: .abbreviated, time: .omitted))
                }
                
                if let nextFertilisingDate {
                    LabeledContent(
                        "Next fertilising",
                        value: nextFertilisingDate.formatted(
                            date: .abbreviated,
                            time: .omitted
                        )
                    )
                }
            }
            
            Section("Plant Health") {
                NavigationLink {
                    PlantHealthQuestionsView(
                        plant: plant
                    )
                } label: {
                    Label(
                        "Check Plant Health",
                        systemImage: "heart.text.square"
                    )
                }
            }
            
            Section("History") {
                NavigationLink {
                    CareHistoryView(plant: plant)
                } label: {
                    Label("Care History", systemImage: "clock.arrow.circlepath")
                }
                
                NavigationLink {
                    AddCareRecordView(plant: plant)
                } label: {
                    Label("Add Care Record", systemImage: "plus.circle")
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
