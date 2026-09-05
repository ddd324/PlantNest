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
    
    private let useCase = CheckPlantHealthUseCase()
    
    func selectSymptom(_ symptom: PlantSymptom) {
        selectedSymptom = symptom
        selectedSoilCondition = nil
        result = nil
        errorMessage = nil
    }
    
    func selectSoilCondition(_ condition: SoilCondition) {
        selectedSoilCondition = condition
        generateResult()
    }
    
    func generateResult() {
        do {
            result = try useCase.excute(symptom: selectedSymptom, soilCondition: selectedSoilCondition)
            errorMessage = nil
        } catch {
            errorMessage = "Unable to check plant health."
        }
    }
}
