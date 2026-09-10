//
//  SoilCondition.swift
//  PlantNest
//
//  Created by Djy on 01/09/2026.
//

import Foundation

/// Represents the soil moisture condition observed by the user.
enum SoilCondition: String, CaseIterable {
    case dry = "Dry"
    case slightlyMoist = "Slightly Moist"
    case wet = "Wet"
}
