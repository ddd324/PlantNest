//
//  ManualAddPlantView.swift
//  PlantNest
//
//  Created by Djy on 04/09/2026.
//

import SwiftUI

struct ManualAddPlantView: View {
    
    let onPlantAdded: () -> Void
    
    @EnvironmentObject private var plantViewModel: PlantViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var plantName = ""
    @State private var species = ""
    @State private var wateringIntervalDays = 7
    @State private var errorMessage: String?
    
    var body: some View {
        Form {
            Section("Plant Information") {
                TextField("Plant name", text: $plantName)
                TextField("Species", text: $species)
            }
            
            Section("Care") {
                Stepper("Water every \(wateringIntervalDays) days", value: $wateringIntervalDays, in: 1...30)
            }
            
            if let errorMessage {
                Section {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                }
            }
            
            Section {
                Button("Add Plant") {
                    addPlant()
                }
            }
        }
        .navigationTitle("Enter Plant Manually")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func addPlant() {
        guard !plantName.isEmpty else {
            errorMessage = "Please enter a plant name."
            return
        }
        
        guard !species.isEmpty else {
            errorMessage = "Please enter a species."
            return
        }
        
        let plant = Plant(name: plantName, species: species, imageName: "", lastWateredDate: Date(), wateringIntervalDays: wateringIntervalDays, imageData: nil)
        
        plantViewModel.addPlant(plant)
        dismiss()
        onPlantAdded()
    }
}

#Preview {
    NavigationStack {
        ManualAddPlantView(onPlantAdded: {})
    }
    .environmentObject(PlantViewModel())
}
