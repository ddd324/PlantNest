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
    
    func execute(candidate: PlantIdentificationCandidate?, name: String, imageData: Data) throws -> Plant {
        guard let candidate else {
            throw ConfirmPlantIdentificationError.noCandidateSelected
        }
        
        return Plant(
            name: name,
            species: candidate.species,
            imageName: "",
            lastWateredDate: Date(),
            wateringIntervalDays: candidate.wateringIntervalDays,
            imageData: imageData
        )
    }
}
