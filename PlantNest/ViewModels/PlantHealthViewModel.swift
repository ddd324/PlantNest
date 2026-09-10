//
//  PlantHealthViewModel.swift
//  PlantNest
//
//  Created by Djy on 05/09/2026.
//

import Foundation
import Combine

final class PlantHealthViewModel: ObservableObject {
    
    @Published var selectedSymptom: PlantSymptom?
    @Published var selectedSoilCondition: SoilCondition?
    @Published var result: PlantHealthResult?
    @Published var errorMessage: String?
    @Published var hasStrongDirectSunlight: Bool?
    @Published var visiblePestSigns: Bool?
    
    private let checkPlantHealthUseCase = CheckPlantHealthUseCase()
    
    func selectSymptom(_ symptom: PlantSymptom) {
        selectedSymptom = symptom
        selectedSoilCondition = nil
        result = nil
        errorMessage = nil
        hasStrongDirectSunlight = nil
        visiblePestSigns = nil
    }
    
    func selectSoilCondition(_ condition: SoilCondition) {
        selectedSoilCondition = condition
        generateResult()
    }
    
    func selectStrongDirectSunlight(_ answer: Bool) {
        hasStrongDirectSunlight = answer
        generateResult()
    }
    
    func selectVisiblePestSigns(_ answer: Bool) {
        visiblePestSigns = answer
        generateResult()
    }
    
    func generateResult() {
        do {
            result = try checkPlantHealthUseCase.execute(symptom: selectedSymptom, soilCondition: selectedSoilCondition, hasStrongDirectSunlight: hasStrongDirectSunlight, visiblePestSigns: visiblePestSigns)
            errorMessage = nil
        } catch {
            errorMessage = "Unable to check plant health."
        }
    }
}
