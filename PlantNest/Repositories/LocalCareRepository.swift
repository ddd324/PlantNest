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
    
    func fetchCareRecords(for plantID: UUID) throws -> [CareRecord] {
        records.filter { record in
            record.plantID == plantID
        }
    }
    
    func addCareRecord(_ record: CareRecord) throws {
        records.append(record)
    }
    
    
}
