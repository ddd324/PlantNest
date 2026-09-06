//
//  GenerateCarePlanUseCase.swift
//  PlantNest
//
//  Created by Djy on 02/09/2026.
//

import Foundation

struct GenerateCareScheduleUseCase {
    
    enum GenerateCarePlanError: Error {
        case invalidWateringInterval
        case invalidFertilisingnterval
    }
    
    struct CareItem: Identifiable {
        let id = UUID()
        let plant: Plant
        let activityType: CareActivityType
        let daysRemaining: Int
    }
    
    struct CarePlan {
        let dueToday: [CareItem]
        let upcoming: [CareItem]
    }
    
    func execute(plants: [Plant], currentDate: Date = Date()) throws -> CarePlan {
        
        var dueToday: [CareItem] = []
        var upcoming: [CareItem] = []
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: currentDate)
        
        for plant in plants {
            // Watering
            guard plant.wateringIntervalDays > 0 else {
                throw GenerateCarePlanError.invalidWateringInterval
            }
            
            if let nextWateringDate = calendar.date(byAdding: .day, value: plant.wateringIntervalDays, to: plant.lastWateredDate) {
                let wateringDay = calendar.startOfDay(for: nextWateringDate)
                let daysRemaining = calendar.dateComponents([.day], from: today, to: wateringDay).day ?? 0
                let item = CareItem(plant: plant, activityType: .watering, daysRemaining: daysRemaining)
                
                if daysRemaining <= 0 {
                    dueToday.append(item)
                } else {
                    upcoming.append(item)
                }
            }
            
            //Fertilising
            if let lastFertilisedDate = plant.lastFertilisedDate, let fertilisingIntervalDays = plant.fertilisingIntervalDays {
                guard fertilisingIntervalDays > 0 else {
                    throw GenerateCarePlanError.invalidFertilisingnterval
                }
                
                if let nextFertilisingDate = calendar.date(byAdding: .day, value: fertilisingIntervalDays, to: lastFertilisedDate) {
                    let fertilisingDay = calendar.startOfDay(for: nextFertilisingDate)
                    let daysRemaining = calendar.dateComponents([.day], from: today, to: fertilisingDay).day ?? 0
                    let item = CareItem(plant: plant, activityType: .fertilising, daysRemaining: daysRemaining)
                    
                    if daysRemaining <= 0 {
                        dueToday.append(item)
                    } else {
                        upcoming.append(item)
                    }
                }
            }
        }
        
        upcoming.sort {
            $0.daysRemaining < $1.daysRemaining
        }
        
        return CarePlan(dueToday: dueToday, upcoming: upcoming)
    }
}
