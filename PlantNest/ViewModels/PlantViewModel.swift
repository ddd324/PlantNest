//
//  PlantViewModel.swift
//  PlantNest
//
//  Created by Djy on 01/09/2026.
//

import Foundation
import Combine

final class PlantViewModel: ObservableObject {
    @Published var plants: [Plant] = []
    
    private let repository: PlantRepository
    
    init(repository: PlantRepository = LocalPlantRepository()) {
        self.repository = repository
    }
    
    func loadPlants() {
        guard plants.isEmpty else {
            return
        }
        
        do {
            plants = try repository.fetchPlants()
        } catch {
            print("Failed to load plants: \(error)")
        }
    }
    
    func addPlant(_ plant: Plant) {
        plants.append(plant)
    }
    
    func updatePlant(_ updatedPlant: Plant) {
        guard let index = plants.firstIndex(where: { $0.id == updatedPlant.id }) else {
            return
        }
        
        plants[index] = updatedPlant
    }
}
