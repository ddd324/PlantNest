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
        case missingFollowUpAnswer
    }
    
    func execute(symptom: PlantSymptom?, soilCondition: SoilCondition?, hasStrongDirectSunlight: Bool?, visiblePestSigns: Bool?) throws -> PlantHealthResult {
        guard let symptom else {
            throw CheckPlantHealthError.missingSymptom
        }
        
        switch symptom {
        case .yellowLeaves:
            guard let soilCondition else {
                throw CheckPlantHealthError.missingFollowUpAnswer
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
            guard let hasStrongDirectSunlight else {
                throw CheckPlantHealthError.missingFollowUpAnswer
            }
            
            if hasStrongDirectSunlight {
                return PlantHealthResult(
                    possibleCause: "Possible Light Stress",
                    guidance: "Strong direct sunlight may be contributing to the brown spots. Consider moving the plant to a location with gentler or indirect light and monitor the leaves."
                )
            } else {
                return PlantHealthResult(
                    possibleCause: "Possible Care or Leaf Stress",
                    guidance: "Direct sunlight may not be the main cause. Check watering, humidity, recent fertilising, and the leaves for signs of damage or pests."
                )
            }
            
        case .drooping:
            guard let soilCondition else {
                throw CheckPlantHealthError.missingFollowUpAnswer
            }
            
            switch soilCondition {
            case .dry:
                return PlantHealthResult(
                    possibleCause: "Possible Underwatering",
                    guidance: "The soil is dry and may be contributing to the drooping. Check whether the plant needs water and continue monitoring its condition."
                )
                
            case .wet:
                return PlantHealthResult(
                    possibleCause: "Possible Overwatering",
                    guidance: "The soil is still wet. Avoid adding more water and check that the pot has suitable drainage."
                )
                
            case .slightlyMoist:
                return PlantHealthResult(
                    possibleCause: "Possible Environmental Stress",
                    guidance: "The soil moisture does not strongly suggest under- or overwatering. Check temperature, light, and recent environmental changes."
                )
            }
            
        case .pests:
            guard let visiblePestSigns else {
                throw CheckPlantHealthError.missingFollowUpAnswer
            }
            
            if visiblePestSigns {
                return PlantHealthResult(
                    possibleCause: "Possible Pest Problem",
                    guidance: "Inspect both sides of the leaves and stems carefully. Consider isolating the plant from other plants while you investigate the pest problem."
                )
            } else {
                return PlantHealthResult(
                    possibleCause: "No Obvious Pest Signs",
                    guidance: "You have not reported visible pest signs. Continue monitoring the plant and check other causes such as watering, light, or physical leaf damage."
                )
            }
        }
    }
}
