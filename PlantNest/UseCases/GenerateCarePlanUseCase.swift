//
//  GenerateCarePlanUseCase.swift
//  PlantNest
//
//  Created by Djy on 02/09/2026.
//

import Foundation

struct GenerateCarePlanUseCase {
    
    enum GenerateCarePlanError: Error {
        case invalidWateringInterval
    }
    
    struct CarePlan {
        let dueToday: [Plant]
        let upcoming: [Plant]
    }
    
    func execute(plants: [Plant], currentDate: Date = Date()) throws -> CarePlan {
        
        var dueToday: [Plant] = []
        var upcoming: [Plant] = []
        
        for plant in plants {
            guard plant.wateringIntervalDays > 0 else {
                throw GenerateCarePlanError.invalidWateringInterval
            }
            
            let nextWateringDate = Calendar.current.date(byAdding: .day, value: plant.wateringIntervalDays, to: plant.lastWateredDate) ?? plant.lastWateredDate
            
            if nextWateringDate <= currentDate {
                dueToday.append(plant)
            } else {
                upcoming.append(plant)
            }
        }
        
        return CarePlan(dueToday: dueToday, upcoming: upcoming)
    }
}
