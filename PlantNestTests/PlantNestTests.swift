//
//  PlantNestTests.swift
//  PlantNestTests
//
//  Created by Djy on 08/09/2026.
//

import Testing
import Foundation
@testable import PlantNest

struct PlantNestTests {
    
    @Test func assessWateringNeed_recommendsWatering_whenSoilIsDry() throws {
        let plant = Plant(name: "Monty", species: "Monstera deliciosa", imageName: "", lastWateredDate: Date(), wateringIntervalDays: 7)
        let useCase = AssessWateringNeedUseCase()
        let result = try useCase.execute(plant: plant, soilCondition: .dry)
        
        #expect(result?.shouldWater == true)
    }
    
    @Test func assessWateringNeed_doesNotRecommendWatering_whenSoilIsSlightlyMoist() throws {
        let plant = Plant(name: "Monty", species: "Monstera deliciosa", imageName: "", lastWateredDate: Date(), wateringIntervalDays: 7)
        let useCase = AssessWateringNeedUseCase()
        let result = try useCase.execute(plant: plant, soilCondition: .slightlyMoist)
        
        #expect(result?.shouldWater == false)
    }
    
    @Test func assessWateringNeed_doesNotRecommendWatering_whenSoilIsWet() throws {
        let plant = Plant(name: "Monty", species: "Monstera deliciosa", imageName: "", lastWateredDate: Date(), wateringIntervalDays: 7)
        let useCase = AssessWateringNeedUseCase()
        let result = try useCase.execute(plant: plant, soilCondition: .wet)
        
        #expect(result?.shouldWater == false)
    }
    
    @Test func assessWateringNeed_fails_whenSoilConditionIsMissing() {
        let plant = Plant(name: "Monty", species: "Monstera deliciosa", imageName: "", lastWateredDate: Date(), wateringIntervalDays: 7)
        let useCase = AssessWateringNeedUseCase()
        
        #expect(throws: AssessWateringNeedUseCase.AssessWateringError.missingSoilCondition) {
            try useCase.execute(plant: plant, soilCondition: nil)
        }
    }
    
    @Test func generateCareSchedule_placesWateringInDueToday_whenWateringIsDueToday() throws {
        let calendar = Calendar.current
        let currentDate = Date()
        let lastWateredDate = calendar.date(byAdding: .day, value: -7, to: currentDate)!
        let plant = Plant(name: "Monty", species: "Monstera deliciosa", imageName: "", lastWateredDate: lastWateredDate, wateringIntervalDays: 7)
        let useCase = GenerateCareScheduleUseCase()
        let result = try useCase.execute(plants: [plant], currentDate: currentDate)
        
        #expect(result.dueToday.count == 1)
        #expect(result.upcoming.isEmpty)
        #expect(result.dueToday.first?.activityType == .watering)
        #expect(result.dueToday.first?.daysRemaining == 0)
    }

    @Test func generateCareSchedule_placesWateringInUpcoming_whenWateringIsNotDueYet() throws {
        let calendar = Calendar.current
        let currentDate = Date()
        let lastWateredDate = calendar.date(byAdding: .day, value: -3, to: currentDate)!
        let plant = Plant(name: "Monty", species: "Monstera deliciosa", imageName: "", lastWateredDate: lastWateredDate, wateringIntervalDays: 7)
        let useCase = GenerateCareScheduleUseCase()
        let result = try useCase.execute(plants: [plant],currentDate: currentDate)

        #expect(result.dueToday.isEmpty)
        #expect(result.upcoming.count == 1)
        #expect(result.upcoming.first?.activityType == .watering)
        #expect(result.upcoming.first?.daysRemaining == 4)
    }
    
    @Test func generateCareSchedule_placesWateringInDueToday_whenWateringIsOverdue() throws {
        let calendar = Calendar.current
        let currentDate = Date()
        let lastWateredDate = calendar.date(byAdding: .day, value: -10, to: currentDate)!
        let plant = Plant(name: "Monty", species: "Monstera deliciosa", imageName: "", lastWateredDate: lastWateredDate, wateringIntervalDays: 7)
        let useCase = GenerateCareScheduleUseCase()
        let result = try useCase.execute(plants: [plant],currentDate: currentDate)

        #expect(result.dueToday.count == 1)
        #expect(result.upcoming.isEmpty)
        #expect(result.dueToday.first?.daysRemaining == -3)
    }
    
    @Test func generateCareSchedule_fails_whenWateringIntervalIsZero() throws {
        let plant = Plant(name: "Monty", species: "Monstera deliciosa", imageName: "", lastWateredDate: Date(), wateringIntervalDays: 0)
        let useCase = GenerateCareScheduleUseCase()
        
        #expect(throws: GenerateCareScheduleUseCase.GenerateCareScheduleError.invalidWateringInterval) {
            try useCase.execute(plants: [plant])
        }
    }
    
    @Test func generateCareSchedule_fails_whenFertilisingIntervalIsZero() throws {
        let plant = Plant(name: "Monty", species: "Monstera deliciosa", imageName: "", lastWateredDate: Date(), wateringIntervalDays: 7, lastFertilisedDate: Date(), fertilisingIntervalDays: 0)
        let useCase = GenerateCareScheduleUseCase()
        
        #expect(throws: GenerateCareScheduleUseCase.GenerateCareScheduleError.invalidFertilisingInterval) {
            try useCase.execute(plants: [plant])
        }
    }
    
    @Test func recordCareActivity_createsRecord_whenCareActivityIsValid() throws {
        let repository = MockCareRepository()
        let plant = Plant(name: "Monty", species: "Monstera deliciosa", imageName: "", lastWateredDate: Date(), wateringIntervalDays: 7)
        let useCase = RecordCareActivityUseCase(repository: repository)
        let record = try useCase.execute(plant: plant, activityType: .watering, date: Date())
        
        #expect(record.plantID == plant.id)
        #expect(record.activityType == .watering)
        #expect(repository.records.count == 1)
    }
    
    @Test func recordCareActivity_fails_whenCareDateIsInFuture() throws {
        let repository = MockCareRepository()
        let plant = Plant(name: "Monty", species: "Monstera deliciosa", imageName: "", lastWateredDate: Date(), wateringIntervalDays: 7)
        let futureDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        let useCase = RecordCareActivityUseCase(repository: repository)
        
        #expect(throws: RecordCareActivityUseCase.RecordCareActivityError.futureDate) {
            try useCase.execute(plant: plant, activityType: .watering, date: futureDate)
        }
    }
    
    @Test func recordCareActivity_fails_whenSameActivityIsRecordedTwiceOnSameDay() throws {
        let repository = MockCareRepository()
        let plant = Plant(name: "Monty", species: "Monstera deliciosa", imageName: "", lastWateredDate: Date(), wateringIntervalDays: 7)
        let useCase = RecordCareActivityUseCase(repository: repository)
        let recordDate = Date()
        _ = try useCase.execute(plant: plant, activityType: .watering, date: recordDate)
        
        #expect(throws: RecordCareActivityUseCase.RecordCareActivityError.duplicateRecord) {
            try useCase.execute(plant: plant, activityType: .watering, date: recordDate)
        }
    }
}
