//
//  PlantCarePlan.swift
//  PlantNest
//
//  Created by Djy on 06/09/2026.
//

import Foundation

/// Represents care guidance for a plant species or genus.
/// Provides recommended care intervals and instructions.
struct PlantCarePlan: Codable {
    let species: String?
    let genus: String
    let wateringIntervalDays: Int
    let fertilisingIntervalDays: Int?
    let waterGuidance: String
    let lightGuidance: String
    let fertilisingGuidance: String
    let repottingGuidance: String
}
