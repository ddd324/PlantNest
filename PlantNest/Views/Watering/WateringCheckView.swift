//
//  WateringCheckView.swift
//  PlantNest
//
//  Created by Djy on 01/09/2026.
//

import SwiftUI

struct WateringCheckView: View {
    
    @State private var selectedSoilCondition: String?
    
    let soilConditionOptions = [
        "Dry",
        "Slightly Moist",
        "Wet"
    ]
    
    var body: some View {
        Form {
            Section("Plant") {
                Text("Monty")
                    .font(.headline)
                
                Text("Last waterd 7 days ago")
                    .foregroundStyle(.secondary)
            }
            
            Section("Check the soil") {
                Text("How does the top soil feel?")
                
                ForEach(soilConditionOptions, id: \.self) { option in
                    Button {
                        selectedSoilCondition = option
                    } label: {
                        HStack {
                            Text(option)
                            
                            Spacer()
                            
                            if selectedSoilCondition == option {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            }
            
            if let recommendation = recommendation {
                Section("Recomendation") {
                    Text(recommendation)
                }
            }
        }
        .navigationTitle("Watering Check")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var recommendation: String? {
        switch selectedSoilCondition {
            case "Dry":
                return "The soil is dry. Monty may be ready for watering."

            case "Slightly Moist":
                return "The soil is still slightly moist. Wait before watering."

            case "Wet":
                return "The soil is wet. Do not water Monty yet."

            default:
                return nil
            }
        }
}

#Preview {
    NavigationStack {
        WateringCheckView()
    }
}
