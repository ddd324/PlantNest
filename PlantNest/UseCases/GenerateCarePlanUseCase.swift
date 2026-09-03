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
    
    struct UpcomingCareItem: Identifiable {
        let plant: Plant
        let daysRemaining: Int
        var id: UUID {
            plant.id
        }
    }
    
    struct CarePlan {
        let dueToday: [Plant]
        let upcoming: [UpcomingCareItem]
    }
    
    func execute(plants: [Plant], currentDate: Date = Date()) throws -> CarePlan {
        
        var dueToday: [Plant] = []
        var upcoming: [UpcomingCareItem] = []
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: currentDate)
        
        for plant in plants {
            guard plant.wateringIntervalDays > 0 else {
                throw GenerateCarePlanError.invalidWateringInterval
            }
            
            guard let nextWateringDate = calendar.date(byAdding: .day, value: plant.wateringIntervalDays, to: plant.lastWateredDate) else {
                continue
            }
            
            let nextWateringDay = calendar.startOfDay(for: nextWateringDate)
            
            let daysRemaining = calendar.dateComponents([.day], from: today, to: nextWateringDay).day ?? 0
            
            if daysRemaining <= 0 {
                dueToday.append(plant)
            } else {
                upcoming.append(UpcomingCareItem(plant: plant, daysRemaining: daysRemaining))
            }
        }
        
        upcoming.sort {
            $0.daysRemaining < $1.daysRemaining
        }
        
        return CarePlan(dueToday: dueToday, upcoming: upcoming)
    }
}
