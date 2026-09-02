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
    @Published var recommendation: AssessWateringNeedUseCase.WateringRecommendation?
    
    @Published var dueToday: [Plant] = []
    @Published var upcoming: [Plant] = []
    
    @Published var recordMessage: String?
    
    private let assessWateringNeedUseCase: AssessWateringNeedUseCase
    private let generateCarePlanUseCase: GenerateCarePlanUseCase
    private let recordCareActivityUseCase: RecordCareActivityUseCase
    
    init(assessWateringNeedUseCase: AssessWateringNeedUseCase = AssessWateringNeedUseCase(), generateCarePlanUseCase: GenerateCarePlanUseCase = GenerateCarePlanUseCase(), recordCareActivityUseCase: RecordCareActivityUseCase = RecordCareActivityUseCase(repository: LocalCareRepository())) {
        self.assessWateringNeedUseCase = assessWateringNeedUseCase
        self.generateCarePlanUseCase = generateCarePlanUseCase
        self.recordCareActivityUseCase = recordCareActivityUseCase
    }
    
    func selectSoilCondition(_ condition: SoilCondition, for plant: Plant) {
        selectedSoilCondition = condition
        
        recommendation = try? assessWateringNeedUseCase.execute(plant: plant, soilCondition: condition)
        
        recordMessage = nil
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
    
    func recordwatering(for plant: Plant) {
        do {
            _ = try recordCareActivityUseCase.execute(plant: plant, activityType: .watering)
            recordMessage = "Watering recorded successfully."
        } catch RecordCareActivityUseCase.RecordCareActivityError.duplicateRecord {
            recordMessage = "Watering has already been recorded today."
        } catch {
            recordMessage = "Unable to record watering."
        }
    }
}
