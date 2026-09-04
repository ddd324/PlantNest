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
    
    private let confirmUseCase = ConfirmPlantIdentificationUseCase()
    
    let candidates: [PlantIdentificationCandidate] = [
        PlantIdentificationCandidate(species: "Monstera deliciosa", confidence: 82, wateringIntervalDays: 7),
        PlantIdentificationCandidate(species: "Philodendron", confidence: 12, wateringIntervalDays: 7),
        PlantIdentificationCandidate(species: "Rhaphidophora tetrasperma", confidence: 6, wateringIntervalDays: 7)
    ]
    
    func selectCandidate(_ candidate: PlantIdentificationCandidate) {
        selectedCandidate = candidate
        errorMessage = nil
    }
    
    func confirmSelection(imageData: Data) {
        do {
            confirmedPlant = try confirmUseCase.execute(candidate: selectedCandidate, name: plantName, imageData: imageData)
        } catch ConfirmPlantIdentificationUseCase.ConfirmPlantIdentificationError.noCandidateSelected {
            errorMessage = "Please select a plant before continuing."
        } catch {
            errorMessage = "Unable to confirm plant identification."
        }
    }
}
