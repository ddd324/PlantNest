//
//  LocalPlantRepository.swift
//  PlantNest
//
//  Created by Djy on 01/09/2026.
//

import Foundation

struct LocalPlantRepository: PlantRepository {
    func fetchPlants() throws -> [Plant] {
        guard let url = Bundle.main.url(
            forResource: "SamplePlants",
            withExtension: "json"
        ) else {
            throw LocalPlantRepositoryError.fileNotFound
        }

        let data = try Data(contentsOf: url)

        let decoder = JSONDecoder()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)

        do {
            return try decoder.decode([Plant].self, from: data)
        } catch {
            throw LocalPlantRepositoryError.decodingFailed
        }
    }
}

enum LocalPlantRepositoryError: Error {
    case fileNotFound
    case decodingFailed
}
