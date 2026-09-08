//
//  PlantRepository.swift
//  PlantNest
//
//  Created by Djy on 01/09/2026.
//

import Foundation

protocol PlantRepository {
    func fetchPlants() throws -> [Plant]
    
    func savePlants(_ plants: [Plant]) throws
}
