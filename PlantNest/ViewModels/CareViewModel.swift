//
//  CareViewModel.swift
//  PlantNest
//
//  Created by Djy on 01/09/2026.
//

import Foundation
import Combine

final class CareViewModel: ObservableObject {
    
    @Published var selectedSoilCondition: SoilCondition?
    @Published var recommendation: String?
    
    @Published var dueToday: [Plant] = []
    @Published var upcoming: [Plant] = []
    
    private let assessWateringNeedUseCase: AssessWateringNeedUseCase
    private let generateCarePlanUseCase: GenerateCarePlanUseCase
    
    init(assessWateringNeedUseCase: AssessWateringNeedUseCase = AssessWateringNeedUseCase(), generateCarePlanUseCase: GenerateCarePlanUseCase = GenerateCarePlanUseCase()) {
        self.assessWateringNeedUseCase = assessWateringNeedUseCase
        self.generateCarePlanUseCase = generateCarePlanUseCase
    }
    
    func selectSoilCondition(_ condition: SoilCondition, for plant: Plant) {
        selectedSoilCondition = condition
        
        recommendation = try? assessWateringNeedUseCase.execute(plant: plant, soilCondition: condition)
    }
    
    func generateCarePlan(for plants: [Plant]) {
        do {
            let carePlan = try generateCarePlanUseCase.execute(plants: plants)
            
            dueToday = carePlan.dueToday
            upcoming = carePlan.upcoming
        } catch {
            print("Failed to generate care plan: \(error)")
        }
    }
}
