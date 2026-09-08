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
    
    private let recordsStorageKey = "savedCareRecords"
    
    init() {
        loadCarePlans()
        loadCareRecords()
    }
    
    func fetchCareRecords(for plantID: UUID) throws -> [CareRecord] {
        records.filter { record in
            record.plantID == plantID
        }
    }
    
    func addCareRecord(_ record: CareRecord) throws {
        records.append(record)
        try saveCareRecords()
    }
    
    func fetchCarePlan(for species: String) -> PlantCarePlan? {
        carePlans.first { carePlan in
            carePlan.species?.lowercased() == species.lowercased()
        }
    }
    
    func fetchCarePlan(forGenus genus: String) -> PlantCarePlan? {
        carePlans.first { carePlan in
            carePlan.species == nil && carePlan.genus.lowercased() == genus.lowercased()
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
    
    private func loadCareRecords() {
        guard let data = UserDefaults.standard.data(forKey: recordsStorageKey) else {
            return
        }
        
        do {
            records = try JSONDecoder().decode([CareRecord].self, from: data)
        } catch {
            print("Failed to load care records: \(error)")
        }
    }
    
    private func saveCareRecords() throws {
        let data = try JSONEncoder().encode(records)
        
        UserDefaults.standard.set(data, forKey: recordsStorageKey)
    }
}
