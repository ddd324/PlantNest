//
//  WateringCheckView.swift
//  PlantNest
//
//  Created by Djy on 01/09/2026.
//

import SwiftUI

struct WateringCheckView: View {
    
    let plant: Plant
    
    @StateObject private var viewModel = CareViewModel()
    
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
                    Text(recommendation)
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
                imageName: "monstera",
                lastWateredDate: Date(),
                wateringIntervalDays: 7
            )
        )
    }
}
