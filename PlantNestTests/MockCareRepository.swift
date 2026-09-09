//
//  MockCareRepository.swift
//  PlantNestTests
//
//  Created by Djy on 09/09/2026.
//

import Foundation
@testable import PlantNest

final class MockCareRepository: CareRepository {

    var records: [CareRecord] = []
    var carePlans: [PlantCarePlan] = []

    func fetchCareRecords(for plantID: UUID) throws -> [CareRecord] {
        records.filter { record in
            record.plantID == plantID
        }
    }

    func addCareRecord(_ record: CareRecord) throws {
        records.append(record)
    }

    func deleteCareRecords(for plantID: UUID) throws {
        records.removeAll { record in
            record.plantID == plantID
        }
    }

    func fetchCarePlan(for species: String) -> PlantCarePlan? {
        carePlans.first { carePlan in
            carePlan.species?.lowercased() == species.lowercased()
        }
    }

    func fetchCarePlan(forGenus genus: String) -> PlantCarePlan? {
        carePlans.first { carePlan in
            carePlan.species == nil &&
            carePlan.genus.lowercased() == genus.lowercased()
        }
    }
}
