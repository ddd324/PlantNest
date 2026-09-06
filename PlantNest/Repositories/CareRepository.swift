//
//  CareRepository.swift
//  PlantNest
//
//  Created by Djy on 02/09/2026.
//

import Foundation

protocol CareRepository {
    func fetchCareRecords (for plantID: UUID) throws -> [CareRecord]
    
    func addCareRecord(_ record: CareRecord) throws
    
    func fetchCarePlan(for species: String) -> PlantCarePlan?
}
