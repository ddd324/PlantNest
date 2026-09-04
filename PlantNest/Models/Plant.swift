//
//  Plant.swift
//  PlantNest
//
//  Created by Djy on 01/09/2026.
//

import Foundation

struct Plant: Identifiable, Codable {
    
    let id: UUID
    var name: String
    var species: String
    var imageName: String
    var lastWateredDate: Date
    var wateringIntervalDays: Int
    var imageData: Data?
    
    init(
        id: UUID = UUID(),
        name: String,
        species: String,
        imageName: String,
        lastWateredDate: Date,
        wateringIntervalDays: Int,
        imageData: Data? = nil
    ) {
        self.id = id
        self.name = name
        self.species = species
        self.imageName = imageName
        self.lastWateredDate = lastWateredDate
        self.wateringIntervalDays = wateringIntervalDays
        self.imageData = imageData
    }
}
