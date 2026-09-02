//
//  CareActivityType.swift
//  PlantNest
//
//  Created by Djy on 02/09/2026.
//

import Foundation

enum CareActivityType: String, Codable, CaseIterable, Equatable {
    case watering = "Watering"
    case fertilising = "Fertilising"
    case repotting = "Repotting"
}
