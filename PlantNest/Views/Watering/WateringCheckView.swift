//
//  WateringCheckView.swift
//  PlantNest
//
//  Created by Djy on 01/09/2026.
//

import SwiftUI

struct WateringCheckView: View {
    
    @State private var selectedSoilCondition: SoilCondition?
    
    private let assessWateringNeedUseCase = AssessWateringNeedUseCase()
    
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
                
                ForEach(SoilCondition.allCases, id: \.self) { condition in
                    Button {
                        selectedSoilCondition = condition
                    } label: {
                        HStack {
                            Text(condition.rawValue)
                            
                            Spacer()
                            
                            if selectedSoilCondition == condition {
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
        guard selectedSoilCondition != nil else {
            return nil
        }
        
        return try? assessWateringNeedUseCase.execute(soilCondition: selectedSoilCondition)
    }
}

#Preview {
    NavigationStack {
        WateringCheckView()
    }
}
