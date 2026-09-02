//
//  AssessWateringNeedUseCase.swift
//  PlantNest
//
//  Created by Djy on 01/09/2026.
//

import Foundation

struct AssessWateringNeedUseCase {
    
    enum AssessWateringError: Error {
        case missingSoilCondition
    }
    
    func execute(plant: Plant, soilCondition: SoilCondition?) throws -> String {
        guard let soilCondition else {
            throw AssessWateringError.missingSoilCondition
        }
        
        switch soilCondition {
        case .dry:
            return "The soil is dry. \(plant.name) may be ready for watering."

        case .slightlyMoist:
            return "The soil is still slightly moist. Wait before watering \(plant.name)."

        case .wet:
            return "The soil is wet. Do not water \(plant.name) yet."
        }
    }
}
