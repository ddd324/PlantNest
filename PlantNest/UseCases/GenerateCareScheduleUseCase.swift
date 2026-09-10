//
//  GenerateCareScheduleUseCase.swift
//  PlantNest
//
//  Created by Djy on 02/09/2026.
//

import Foundation

/// Generates today's and upcoming care tasks for the user's plants.
struct GenerateCareScheduleUseCase {
    
    enum GenerateCareScheduleError: Error {
        case invalidWateringInterval
        case invalidFertilisingInterval
    }
    
    struct CareTask: Identifiable {
        let id = UUID()
        let plant: Plant
        let activityType: CareActivityType
        let daysRemaining: Int
    }
    
    struct CareSchedule {
        let dueToday: [CareTask]
        let upcoming: [CareTask]
    }
    
    func execute(plants: [Plant], currentDate: Date = Date()) throws -> CareSchedule {
        
        var dueToday: [CareTask] = []
        var upcoming: [CareTask] = []
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: currentDate)
        
        for plant in plants {
            // Watering
            guard plant.wateringIntervalDays > 0 else {
                throw GenerateCareScheduleError.invalidWateringInterval
            }
            
            if let nextWateringDate = calendar.date(byAdding: .day, value: plant.wateringIntervalDays, to: plant.lastWateredDate) {
                let wateringDay = calendar.startOfDay(for: nextWateringDate)
                let daysRemaining = calendar.dateComponents([.day], from: today, to: wateringDay).day ?? 0
                let item = CareTask(plant: plant, activityType: .watering, daysRemaining: daysRemaining)
                
                if daysRemaining <= 0 {
                    dueToday.append(item)
                } else {
                    upcoming.append(item)
                }
            }
            
            // Fertilising
            if let lastFertilisedDate = plant.lastFertilisedDate, let fertilisingIntervalDays = plant.fertilisingIntervalDays {
                guard fertilisingIntervalDays > 0 else {
                    throw GenerateCareScheduleError.invalidFertilisingInterval
                }
                
                if let nextFertilisingDate = calendar.date(byAdding: .day, value: fertilisingIntervalDays, to: lastFertilisedDate) {
                    let fertilisingDay = calendar.startOfDay(for: nextFertilisingDate)
                    let daysRemaining = calendar.dateComponents([.day], from: today, to: fertilisingDay).day ?? 0
                    let item = CareTask(plant: plant, activityType: .fertilising, daysRemaining: daysRemaining)
                    
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
        
        return CareSchedule(dueToday: dueToday, upcoming: upcoming)
    }
}
