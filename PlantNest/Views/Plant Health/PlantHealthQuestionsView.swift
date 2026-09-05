//
//  PlantHealthQuestionsView.swift
//  PlantNest
//
//  Created by Djy on 05/09/2026.
//

import SwiftUI

struct PlantHealthQuestionsView: View {
    
    let plant: Plant
    
    @StateObject private var plantHealthViewModel = PlantHealthViewModel()
    
    var body: some View {
        Form {
            Section("Plant") {
                Text(plant.name)
                    .font(.headline)
                
                Text(plant.species)
                    .foregroundStyle(.secondary)
            }
            
            Section("What are you noticing?") {
                ForEach(PlantSymptom.allCases, id: \.self) { symptom in
                    Button {
                        plantHealthViewModel.selectedSymptom = symptom
                    } label: {
                        HStack {
                            Text(symptom.rawValue)
                                .foregroundStyle(.primary)
                            
                            Spacer()
                            
                            if plantHealthViewModel.selectedSymptom == symptom {
                                Image(systemName: "checkmark.circle.fill")
                            }
                        }
                    }
                    
                }
            }
            
            if plantHealthViewModel.selectedSymptom == .yellowLeaves {
                Section("How Does the soil feel?") {
                    ForEach(SoilCondition.allCases, id: \.self) { condition in
                        Button {
                            plantHealthViewModel.selectedSoilCondition = condition
                        } label: {
                            HStack {
                                Text(condition.rawValue)
                                    .foregroundStyle(.primary)
                                
                                Spacer()
                                
                                if plantHealthViewModel.selectedSoilCondition == condition {
                                    Image(systemName: "checkmark.circle.fill")
                                }
                            }
                        }
                    }
                }
                
            }
            
            if let symptom = plantHealthViewModel.selectedSymptom {
                if symptom == .yellowLeaves {
                    if plantHealthViewModel.selectedSoilCondition != nil {
                        Section {
                            Button("View Result") {
                                plantHealthViewModel.generateResult()
                            }
                        }
                    }
                } else {
                    Section {
                        Button("View Result") {
                            plantHealthViewModel.generateResult()
                        }
                    }
                }
            }
            
            if let result = plantHealthViewModel.result {
                Section("Possible Cause") {
                    Text(result.possibleCause)
                        .font(.headline)
                }
                
                Section("Care Guidence") {
                    Text(result.guidance)
                }
            }
        }
        .navigationTitle("Plant Health")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        PlantHealthQuestionsView(
            plant: Plant(
                name: "Monty",
                species: "Monstera deliciosa",
                imageName: "",
                lastWateredDate: Date(),
                wateringIntervalDays: 7
            )
        )
    }
}
