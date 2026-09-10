//
//  AssessWateringNeedUseCase.swift
//  PlantNest
//
//  Created by Djy on 01/09/2026.
//

import Foundation

/// Assesses whether a plant should be watered based on the user's observed soil condition.
struct AssessWateringNeedUseCase {
    
    enum AssessWateringError: Error {
        case missingSoilCondition
    }
    
    struct WateringRecommendation {
        let message: String
        let shouldWater: Bool
    }
    
    func execute(plant: Plant, soilCondition: SoilCondition?) throws -> WateringRecommendation? {
        guard let soilCondition else {
            throw AssessWateringError.missingSoilCondition
        }
        
        switch soilCondition {
        case .dry:
            return WateringRecommendation(message: "The soil is dry. \(plant.name) may be ready for watering.", shouldWater: true)
            

        case .slightlyMoist:
            return WateringRecommendation(message: "The soil is still slightly moist. Wait before watering \(plant.name).", shouldWater: false)

        case .wet:
            return WateringRecommendation(message: "The soil is wet. Do not water \(plant.name) yet.", shouldWater: false)
        }
    }
}
