//
//  PlantSymptom.swift
//  PlantNest
//
//  Created by Djy on 05/09/2026.
//

import Foundation

/// Represents a visible plant health symptom selected by the user.
enum PlantSymptom: String, CaseIterable {
    case yellowLeaves = "Yellow Leaves"
    case brownSpots = "Brown Spots"
    case drooping = "Drooping"
    case pests = "Pests"
}
