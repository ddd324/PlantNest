//
//  MockPlantRepository.swift
//  PlantNestTests
//
//  Created by Djy on 10/09/2026.
//

import Foundation
@testable import PlantNest

final class MockPlantRepository: PlantRepository {

    var plants: [Plant] = []
    var savedPlants: [Plant] = []

    func fetchPlants() throws -> [Plant] {
        plants
    }

    func savePlants(_ plants: [Plant]) throws {
        savedPlants = plants
    }
}
