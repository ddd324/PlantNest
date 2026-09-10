//
//  WateringCheckView.swift
//  PlantNest
//
//  Created by Djy on 01/09/2026.
//

import SwiftUI

struct WateringCheckView: View {
    
    let plant: Plant
    
    @EnvironmentObject private var careRepository: LocalCareRepository
    @EnvironmentObject private var plantViewModel: PlantViewModel
    @StateObject private var viewModel = CareViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Form {
            Section("Plant") {
                LabeledContent("Name", value: plant.name)
                
                LabeledContent("Last watered", value: plant.lastWateredDate.formatted(date: .abbreviated, time: .omitted))
            }
            
            Section("Check the soil") {
                ForEach(SoilCondition.allCases, id: \.self) { condition in
                    Button {
                        viewModel.selectSoilCondition(condition, for: plant)
                    } label: {
                        HStack {
                            Text(condition.rawValue)
                            
                            Spacer()
                            
                            if viewModel.selectedSoilCondition == condition {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            }
            
            if let recommendation = viewModel.recommendation {
                Section("Recomendation") {
                    Text(recommendation.message)
                    
                    if recommendation.shouldWater {
                        Button("Record Watering") {
                            if let updatedPlant = viewModel.recordWatering(for: plant, repository: careRepository) {
                                plantViewModel.updatePlant(updatedPlant)
                                dismiss()
                            }
                        }
                    }
                }
            }
            
            if let recordMessage = viewModel.recordMessage {
                Section {
                    Text(recordMessage)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle("Watering Check")
        .navigationBarTitleDisplayMode(.inline)
    }
    
}

#Preview {
    NavigationStack {
        WateringCheckView(
            plant: Plant(
                name: "Monty",
                species: "Monstera deliciosa",
                imageName: "",
                lastWateredDate: Date(),
                wateringIntervalDays: 7
            )
        )
    }
    .environmentObject(LocalCareRepository())
    .environmentObject(PlantViewModel())
}
