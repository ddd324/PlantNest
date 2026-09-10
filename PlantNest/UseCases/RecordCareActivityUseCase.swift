//
//  RecordCareActivityUseCase.swift
//  PlantNest
//
//  Created by Djy on 02/09/2026.
//

import Foundation

/// Records a plant care activity while preventing invalid or duplicate records.
struct RecordCareActivityUseCase {
    
    enum RecordCareActivityError: Error {
        case futureDate
        case duplicateRecord
    }
    
    private let repository: CareRepository
    
    init(repository: CareRepository) {
        self.repository = repository
    }
    
    func execute(plant: Plant, activityType: CareActivityType, date: Date = Date()) throws -> CareRecord {
        let calendar = Calendar.current
        
        guard date <= Date() else {
            throw RecordCareActivityError.futureDate
        }
        
        // Prevent the same care activity from being recorded twice on the same day.
        let existingRecords = try repository.fetchCareRecords(for: plant.id)
        let isDuplicate = existingRecords.contains { record in
            record.activityType == activityType && calendar.isDate(record.date, inSameDayAs: date)
        }
        
        guard !isDuplicate else {
            throw RecordCareActivityError.duplicateRecord
        }
        
        let record = CareRecord(plantID: plant.id, activityType: activityType,date: date)
        
        try repository.addCareRecord(record)
        
        return record
    }
}
