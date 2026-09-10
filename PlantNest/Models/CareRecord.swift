//
//  CareRecord.swift
//  PlantNest
//
//  Created by Djy on 02/09/2026.
//

import Foundation

/// Represents a care activity recorded for a plant.
struct CareRecord: Identifiable, Codable {
    let id: UUID
    let plantID: UUID
    let activityType: CareActivityType
    let date: Date
    
    init(id: UUID = UUID(), plantID: UUID, activityType: CareActivityType, date: Date = Date()) {
        self.id = id
        self.plantID = plantID
        self.activityType = activityType
        self.date = date
    }
}
