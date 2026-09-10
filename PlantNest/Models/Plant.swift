//
//  Plant.swift
//  PlantNest
//
//  Created by Djy on 01/09/2026.
//

import Foundation

/// Represents an indoor plant owned and cared for by the user.
/// Stores the plant's identity and care timing information.
struct Plant: Identifiable, Codable, Equatable {
    
    let id: UUID
    var name: String
    var species: String
    var imageName: String
    var lastWateredDate: Date
    var wateringIntervalDays: Int
    var imageData: Data?
    var lastFertilisedDate: Date?
    var fertilisingIntervalDays: Int?
    
    init(
        id: UUID = UUID(),
        name: String,
        species: String,
        imageName: String,
        lastWateredDate: Date,
        wateringIntervalDays: Int,
        imageData: Data? = nil,
        lastFertilisedDate: Date? = nil,
        fertilisingIntervalDays: Int? = nil
    ) {
        self.id = id
        self.name = name
        self.species = species
        self.imageName = imageName
        self.lastWateredDate = lastWateredDate
        self.wateringIntervalDays = wateringIntervalDays
        self.imageData = imageData
        self.lastFertilisedDate = lastFertilisedDate
        self.fertilisingIntervalDays = fertilisingIntervalDays
    }
}
