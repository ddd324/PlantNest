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
    
    private let assessWateringNeedUseCase: AssessWateringNeedUseCase
    
    init(assessWateringNeedUseCase: AssessWateringNeedUseCase = AssessWateringNeedUseCase()) {
        self.assessWateringNeedUseCase = assessWateringNeedUseCase
    }
    
    func selectSoilCondition(_ condition: SoilCondition) {
        selectedSoilCondition = condition
        
        recommendation = try? assessWateringNeedUseCase.execute(soilCondition: condition)
    }
}
