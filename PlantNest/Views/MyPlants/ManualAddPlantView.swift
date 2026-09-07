//
//  ManualAddPlantView.swift
//  PlantNest
//
//  Created by Djy on 04/09/2026.
//

import SwiftUI
import PhotosUI

struct ManualAddPlantView: View {
    
    let onPlantAdded: () -> Void
    
    @EnvironmentObject private var plantViewModel: PlantViewModel
    @EnvironmentObject private var careRepository: LocalCareRepository
    @Environment(\.dismiss) private var dismiss
    
    @State private var plantName = ""
    @State private var species = ""
    @State private var wateringIntervalDays = 7
    @State private var errorMessage: String?
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedImageData: Data?
    
    var body: some View {
        Form {
            Section("Plant Photo") {
                if let selectedImageData, let uiImage = UIImage(data: selectedImageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 220)
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    PhotosPicker(selection: $selectedPhoto, matching: .images) {
                        Label("Change Photo", systemImage: "photo")
                    }
                } else {
                    PhotosPicker(selection: $selectedPhoto, matching: .images) {
                        VStack(spacing: 12) {
                            Image(systemName: "photo")
                                .font(.system(size: 40))
                            
                            Text("Add Photo")
                                .font(.headline)
                            
                            Text("Optional")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 150)
                    }
                    .buttonStyle(.plain)
                }
            }
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
        .onChange(of: selectedPhoto) { _, newPhoto in
            Task {
                selectedImageData = try? await newPhoto?.loadTransferable(type: Data.self)
            }
        }
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
        
        let carePlan = careRepository.fetchCarePlan(for: species)
        
        let plant = Plant(name: plantName, species: species, imageName: "", lastWateredDate: Date(), wateringIntervalDays: wateringIntervalDays, imageData: selectedImageData, lastFertilisedDate: nil, fertilisingIntervalDays: carePlan?.fertilisingIntervalDays)
        
        plantViewModel.addPlant(plant)
        onPlantAdded()
    }
}

#Preview {
    NavigationStack {
        ManualAddPlantView(onPlantAdded: {})
    }
    .environmentObject(PlantViewModel())
    .environmentObject(LocalCareRepository())
}
