//
//  PlantCarePlan.swift
//  PlantNest
//
//  Created by Djy on 06/09/2026.
//

import Foundation

struct PlantCarePlan: Codable {
    let species: String
    let genus: String
    let wateringIntervalDays: Int
    let fertilisingIntervalDays: Int?
    let waterGuidance: String
    let lightGuidance: String
    let fertilisingGuidance: String
    let repottingGuidance: String
}
