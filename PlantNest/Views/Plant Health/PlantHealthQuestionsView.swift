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
                        plantHealthViewModel.selectSymptom(symptom)
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
                Section("How does the soil feel?") {
                    ForEach(SoilCondition.allCases, id: \.self) { condition in
                        Button {
                            plantHealthViewModel.selectSoilCondition(condition)
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

            if plantHealthViewModel.selectedSymptom == .brownSpots {
                Section("Is the plant in strong direct sunlight?") {
                    Button {
                        plantHealthViewModel.selectStrongDirectSunlight(true)
                    } label: {
                        HStack {
                            Text("Yes")
                                .foregroundStyle(.primary)

                            Spacer()

                            if plantHealthViewModel.hasStrongDirectSunlight == true {
                                Image(systemName: "checkmark.circle.fill")
                            }
                        }
                    }

                    Button {
                        plantHealthViewModel.selectStrongDirectSunlight(false)
                    } label: {
                        HStack {
                            Text("No")
                                .foregroundStyle(.primary)

                            Spacer()

                            if plantHealthViewModel.hasStrongDirectSunlight == false {
                                Image(systemName: "checkmark.circle.fill")
                            }
                        }
                    }
                }
            }

            if plantHealthViewModel.selectedSymptom == .drooping {
                Section("How does the soil feel?") {
                    ForEach(SoilCondition.allCases, id: \.self) { condition in
                        Button {
                            plantHealthViewModel.selectSoilCondition(condition)
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

            if plantHealthViewModel.selectedSymptom == .pests {
                Section("Can you see insects, webbing, or sticky residue?") {
                    Button {
                        plantHealthViewModel.selectVisiblePestSigns(true)
                    } label: {
                        HStack {
                            Text("Yes")
                                .foregroundStyle(.primary)

                            Spacer()

                            if plantHealthViewModel.visiblePestSigns == true {
                                Image(systemName: "checkmark.circle.fill")
                            }
                        }
                    }

                    Button {
                        plantHealthViewModel.selectVisiblePestSigns(false)
                    } label: {
                        HStack {
                            Text("No")
                                .foregroundStyle(.primary)

                            Spacer()

                            if plantHealthViewModel.visiblePestSigns == false {
                                Image(systemName: "checkmark.circle.fill")
                            }
                        }
                    }
                }
            }

            if let result = plantHealthViewModel.result {
                Section("Possible Cause") {
                    Text(result.possibleCause)
                        .font(.headline)
                }

                Section("Care Guidance") {
                    Text(result.guidance)
                }
            }
        }
        .navigationTitle("Plant Health")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var canShowResult: Bool {
        guard let symptom = plantHealthViewModel.selectedSymptom else {
            return false
        }

        switch symptom {
        case .yellowLeaves:
            return plantHealthViewModel.selectedSoilCondition != nil

        case .brownSpots:
            return plantHealthViewModel.hasStrongDirectSunlight != nil

        case .drooping:
            return plantHealthViewModel.selectedSoilCondition != nil

        case .pests:
            return plantHealthViewModel.visiblePestSigns != nil
        }
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
