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
    private let generateCareScheduleUseCase: GenerateCareScheduleUseCase
    
    init(assessWateringNeedUseCase: AssessWateringNeedUseCase = AssessWateringNeedUseCase(), generateCareScheduleUseCase: GenerateCareScheduleUseCase = GenerateCareScheduleUseCase()) {
        self.assessWateringNeedUseCase = assessWateringNeedUseCase
        self.generateCareScheduleUseCase = generateCareScheduleUseCase
    }
    
    func selectSoilCondition(_ condition: SoilCondition, for plant: Plant) {
        selectedSoilCondition = condition
        
        recommendation = try? assessWateringNeedUseCase.execute(plant: plant, soilCondition: condition)
        
        recordMessage = nil
    }
    
    func generateCareSchedule(for plants: [Plant]) {
        do {
            let careSchedule = try generateCareScheduleUseCase.execute(plants: plants)
            
            dueToday = careSchedule.dueToday
            upcoming = careSchedule.upcoming
        } catch {
            print("Failed to generate care schedule: \(error)")
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
            recordMessage = "Watering could not be recorded. Please try again."
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
