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
    
    @Published var dueToday: [GenerateCareScheduleUseCase.CareTask] = []
    @Published var upcoming: [GenerateCareScheduleUseCase.CareTask] = []
    
    @Published var recordMessage: String?
    
    private let assessWateringNeedUseCase: AssessWateringNeedUseCase
    private let generateCarePlanUseCase: GenerateCareScheduleUseCase
    
    init(assessWateringNeedUseCase: AssessWateringNeedUseCase = AssessWateringNeedUseCase(), generateCarePlanUseCase: GenerateCareScheduleUseCase = GenerateCareScheduleUseCase()) {
        self.assessWateringNeedUseCase = assessWateringNeedUseCase
        self.generateCarePlanUseCase = generateCarePlanUseCase
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
    
    func recordWatering(for plant: Plant, repository: CareRepository) -> Plant? {
        
        let useCase = RecordCareActivityUseCase(repository: repository)
        
        do {
            let record = try useCase.execute(plant: plant, activityType: .watering)
            recordMessage = "Watering recorded successfully."
            
            var updatedPlant = plant
            updatedPlant.lastWateredDate = record.date
            return updatedPlant
        } catch RecordCareActivityUseCase.RecordCareActivityError.duplicateRecord {
            recordMessage = "Watering has already been recorded today."
            return nil
        } catch {
            recordMessage = "Unable to record watering."
            return nil
        }
    }
    
    func updatePlant(after record: CareRecord, originalPlant: Plant) -> Plant {
        var updatedPlant = originalPlant
        
        switch record.activityType {
        case .watering:
            updatedPlant.lastWateredDate = record.date
            
        case .fertilising:
            updatedPlant.lastFertilisedDate = record.date
            
        case .repotting:
            break
            
        case .pruning:
            break
        }
        
        return updatedPlant
    }
}
