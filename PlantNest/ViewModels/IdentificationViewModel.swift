//
//  IdentificationViewModel.swift
//  PlantNest
//
//  Created by Djy on 03/09/2026.
//

import Foundation
import Combine

final class IdentificationViewModel: ObservableObject {
    
    @Published var selectedCandidate: PlantIdentificationCandidate?
    @Published var confirmedPlant: Plant?
    @Published var errorMessage: String?
    @Published var plantName: String = ""
    @Published var useManualSpecies: Bool = false
    @Published var manualSpecies: String = ""
    
    let candidates: [PlantIdentificationCandidate] = [
        PlantIdentificationCandidate(species: "Monstera deliciosa", confidence: 82),
        PlantIdentificationCandidate(species: "Philodendron", confidence: 12),
        PlantIdentificationCandidate(species: "Rhaphidophora tetrasperma", confidence: 6)
    ]
    
    func selectCandidate(_ candidate: PlantIdentificationCandidate) {
        selectedCandidate = candidate
        useManualSpecies = false
        manualSpecies = ""
        errorMessage = nil
    }
    
    func confirmSelection(imageData: Data, careRepository: CareRepository) {
        confirmedPlant = nil
        errorMessage = nil
        
        guard !plantName.isEmpty else {
                errorMessage = "Please enter a plant name."
                return
            }
        
        let species: String
        
        if useManualSpecies {
            guard !manualSpecies.isEmpty else {
                errorMessage = "Please enter a species."
                return
            }
            species = manualSpecies
        } else {
            guard let selectedCandidate else {
                errorMessage = "Please select a species."
                return
            }
            species = selectedCandidate.species
        }
        
        let confirmPlantIdentificationUseCase = ConfirmPlantIdentificationUseCase(careRepository: careRepository)
        
        do {
            confirmedPlant = try confirmPlantIdentificationUseCase.execute(species: species, name: plantName, imageData: imageData)
            errorMessage = nil
        } catch {
            errorMessage = "Unable to add this plant. Please try again."
        }
    }
}
