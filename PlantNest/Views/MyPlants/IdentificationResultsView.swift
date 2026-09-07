//
//  IdentificationResultsView.swift
//  PlantNest
//
//  Created by Djy on 03/09/2026.
//

import SwiftUI

struct IdentificationResultsView: View {
    
    let selectedImageData: Data
    let onPlantAdded: () -> Void
    
    @StateObject private var identificationViewModel = IdentificationViewModel()
    @EnvironmentObject private var plantViewModel: PlantViewModel
    @EnvironmentObject private var careRepository: LocalCareRepository
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        List {
            Section {
                if let uiImage = UIImage(data: selectedImageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 220)
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            Section {
                Text("We found a few possible matches. Choose your plant species.")
                    .foregroundStyle(.secondary)
            }
            
            Section("Possible Matches") {
                ForEach(identificationViewModel.candidates, id: \.species) { candidate in
                    Button {
                        identificationViewModel.selectCandidate(candidate)
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(candidate.species)
                                    .font(.headline)
                                    .foregroundStyle(.primary)
                                
                                Text("\(candidate.confidence)% match")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            
                            Spacer()
                            
                            if identificationViewModel.selectedCandidate?.species == candidate.species {
                                Image(systemName: "checkmark.circle.fill")
                            }
                                
                        }
                    }
                }
            }
            
            Section {
                Button {
                    identificationViewModel.useManualSpecies = true
                    identificationViewModel.selectedCandidate = nil
                    identificationViewModel.errorMessage = nil
                } label: {
                    Label("My plant isn't listed", systemImage: "pencil")
                }
                
                if identificationViewModel.useManualSpecies {
                    TextField("Scientific name", text: $identificationViewModel.manualSpecies)
                    
                    Text("e.g. Monstera adansonii")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            Section("Plant Name") {
                TextField("Enter a name for your plant", text: $identificationViewModel.plantName)
            }
            
            if let errorMessage = identificationViewModel.errorMessage {
                Section {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                }
            }
            
            Section {
                Button("Confirm Plant") {
                    identificationViewModel.confirmSelection(imageData: selectedImageData, careRepository: careRepository)
                    
                    if let confirmedPlant = identificationViewModel.confirmedPlant {
                        plantViewModel.addPlant(confirmedPlant)
                        onPlantAdded()
                    }
                }
            }
        }
        .navigationTitle("Identification Results")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        IdentificationResultsView(selectedImageData: Data(), onPlantAdded: {})
    }
    .environmentObject(PlantViewModel())
    .environmentObject(LocalCareRepository())
}
