//
//  ConfirmPlantIdentificationUseCase.swift
//  PlantNest
//
//  Created by Djy on 03/09/2026.
//

import Foundation

struct ConfirmPlantIdentificationUseCase {
    enum ConfirmPlantIdentificationError: Error {
        case noCandidateSelected
    }
    
    private let careRepository: CareRepository
    
    init(careRepository: CareRepository) {
        self.careRepository = careRepository
    }
    
    func execute(candidate: PlantIdentificationCandidate?, name: String, imageData: Data) throws -> Plant {
        guard let candidate else {
            throw ConfirmPlantIdentificationError.noCandidateSelected
        }
        
        let carePlan = careRepository.fetchCarePlan(for: candidate.species)
        
        return Plant(
            name: name,
            species: candidate.species,
            imageName: "",
            lastWateredDate: Date(),
            wateringIntervalDays: carePlan?.wateringIntervalDays ?? 7,
            imageData: imageData,
            lastFertilisedDate: nil,
            fertilisingIntervalDays: carePlan?.fertilisingIntervalDays ?? 28
        )
    }
}
