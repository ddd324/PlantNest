//
//  LocalPlantRepository.swift
//  PlantNest
//
//  Created by Djy on 01/09/2026.
//

import Foundation

struct LocalPlantRepository: PlantRepository {
    
    private let storageKey = "savedPlants"
    
    func fetchPlants() throws -> [Plant] {
        if let savedData = UserDefaults.standard.data(forKey: storageKey) {
            do {
                let decoder = JSONDecoder()
                return try decoder.decode([Plant].self, from: savedData)
            } catch {
                throw LocalPlantRepositoryError.decodingFailed
            }
        }
        
        guard let url = Bundle.main.url(forResource: "SamplePlants", withExtension: "json") else {
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
    
    func savePlants(_ plants: [Plant]) throws {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(plants)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            throw LocalPlantRepositoryError.encodingFailed
        }
    }
}

enum LocalPlantRepositoryError: Error {
    case fileNotFound
    case decodingFailed
    case encodingFailed
}
