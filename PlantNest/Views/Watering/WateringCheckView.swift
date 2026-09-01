//
//  WateringCheckView.swift
//  PlantNest
//
//  Created by Djy on 01/09/2026.
//

import SwiftUI

struct WateringCheckView: View {
    
    @StateObject private var viewModel = CareViewModel()
    
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
                        viewModel.selectSoilCondition(condition)
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
        WateringCheckView()
    }
}
