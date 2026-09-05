//
//  CheckPlantHealthUseCase.swift
//  PlantNest
//
//  Created by Djy on 05/09/2026.
//

import Foundation

struct CheckPlantHealthUseCase {
    enum CheckPlantHealthError: Error {
        case missingSymptom
        case missingSoilCondition
    }
    
    func excute(symptom: PlantSymptom?, soilCondition: SoilCondition?) throws -> PlantHealthResult {
        guard let symptom else {
            throw CheckPlantHealthError.missingSymptom
        }
        
        switch symptom {
        case .yellowLeaves:
            guard let soilCondition else {
                throw CheckPlantHealthError.missingSoilCondition
            }
            
            switch soilCondition {
            case .wet:
                return PlantHealthResult(
                    possibleCause: "Possible Overwatering",
                    guidance: "Let the soil dry before watering again. Check that the pot drains well and avoid watering only because the schedule says it is due."
                )
                
            case .dry:
                return PlantHealthResult(
                    possibleCause: "Possible Underwatering",
                    guidance: "The soil is dry. Check whether the plant needs water and monitor whether the leaves improve after watering."
                )
                
            case .slightlyMoist:
                return PlantHealthResult(
                    possibleCause: "Watering May Not Be the Main Cause",
                    guidance: "The soil is still slightly moist. Check other factors such as light conditions, recent fertilising, or leaf damage."
                )
            }
            
        case .brownSpots:
            return PlantHealthResult(
                possibleCause: "Possible Leaf Stress",
                guidance: "Check watering, light exposure, and the leaves for signs of pests or damage."
            )
            
        case .drooping:
            return PlantHealthResult(
                possibleCause: "Possible Watering or Environmental Stress",
                guidance: "Check the soil moisture first, then review recent watering and environmental conditions."
            )
            
        case .pests:
            return PlantHealthResult(
                possibleCause: "Possible Pest Problem",
                guidance: "Inspect both sides of the leaves and stems for insects, webbing, or unusual marks."
            )
        }
    }
}
