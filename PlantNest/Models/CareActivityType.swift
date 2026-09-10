//
//  CareActivityType.swift
//  PlantNest
//
//  Created by Djy on 02/09/2026.
//

import Foundation

/// Represents the types of care activities that can be recorded for a plant.
enum CareActivityType: String, Codable, CaseIterable, Equatable {
    case watering = "Watering"
    case fertilising = "Fertilising"
    case repotting = "Repotting"
    case pruning = "Pruning"
}
