//
//  LocalCareRepository.swift
//  PlantNest
//
//  Created by Djy on 02/09/2026.
//

import Foundation
import Combine

final class LocalCareRepository: CareRepository, ObservableObject {
    
    private var records: [CareRecord] = []
    private var carePlans: [PlantCarePlan] = []
    
    init() {
        loadCarePlans()
    }
    
    func fetchCareRecords(for plantID: UUID) throws -> [CareRecord] {
        records.filter { record in
            record.plantID == plantID
        }
    }
    
    func addCareRecord(_ record: CareRecord) throws {
        records.append(record)
    }
    
    func fetchCarePlan(for species: String) -> PlantCarePlan? {
        carePlans.first { carePlan in
            carePlan.species.lowercased() == species.lowercased()
        }
    }
    
    private func loadCarePlans() {
        guard let url = Bundle.main.url(forResource: "SamplePlantCarePlans", withExtension: "json") else {
            print("SamplePlantCarePlans.json not found")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            carePlans = try JSONDecoder().decode([PlantCarePlan].self, from: data)
        } catch {
            print("Failed to load care plans: \(error)")
        }
    }
}
