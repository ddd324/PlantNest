//
//  ConfirmPlantIdentificationUseCase.swift
//  PlantNest
//
//  Created by Djy on 03/09/2026.
//

import Foundation

struct ConfirmPlantIdentificationUseCase {
    
    enum ConfirmPlantIdentificationError: Error {
            case missingName
            case missingSpecies
        }
    
    private let careRepository: CareRepository
    
    init(careRepository: CareRepository) {
        self.careRepository = careRepository
    }
    
    func execute(species: String, name: String, imageData: Data) throws -> Plant {
        guard !name.isEmpty else {
            throw ConfirmPlantIdentificationError.missingName
        }
        
        guard !species.isEmpty else {
            throw ConfirmPlantIdentificationError.missingSpecies
        }
        
        let getCarePlanUseCase = GetCarePlanUseCase(repository: careRepository)
        
        let carePlan = try? getCarePlanUseCase.execute(species: species)
        
        return Plant(
            name: name,
            species: species,
            imageName: "",
            lastWateredDate: Date(),
            wateringIntervalDays: carePlan?.wateringIntervalDays ?? 7,
            imageData: imageData,
            lastFertilisedDate: nil,
            fertilisingIntervalDays: carePlan?.fertilisingIntervalDays
        )
    }
}
