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
    
    @Test func checkPlantHealth_identifiesPossibleOverwatering_whenYellowLeavesAndSoilIsWet() throws {
        let useCase = CheckPlantHealthUseCase()
        let result = try useCase.execute(symptom: .yellowLeaves, soilCondition: .wet, hasStrongDirectSunlight: nil, visiblePestSigns: nil)
        
        #expect(result.possibleCause == "Possible Overwatering")
    }
    
    @Test func checkPlantHealth_identifiesPossiblePestProblem_whenVisiblePestSignsAreReported() throws {
        let useCase = CheckPlantHealthUseCase()
        let result = try useCase.execute(symptom: .pests, soilCondition: nil, hasStrongDirectSunlight: nil, visiblePestSigns: true)
        
        #expect(result.possibleCause == "Possible Pest Problem")
    }
    
    @Test func checkPlantHealth_fails_whenSymptomIsMissing() throws {
        let useCase = CheckPlantHealthUseCase()
        
        #expect(throws: CheckPlantHealthUseCase.CheckPlantHealthError.missingSymptom) {
            try useCase.execute(symptom: nil, soilCondition: nil, hasStrongDirectSunlight: nil, visiblePestSigns: nil)
        }
    }
    
    @Test func checkPlantHealth_fails_whenFollowUpAnswerIsMissing() throws {
        let useCase = CheckPlantHealthUseCase()
        
        #expect(throws: CheckPlantHealthUseCase.CheckPlantHealthError.missingFollowUpAnswer) {
            try useCase.execute(symptom: .yellowLeaves, soilCondition: nil, hasStrongDirectSunlight: nil, visiblePestSigns: nil)
        }
    }
    
    @Test func getCarePlan_returnsExactSpeciesPlan_whenSpeciesMatchExists() {
        let repository = MockCareRepository()
        repository.carePlans = [
            PlantCarePlan(
                species: "Monstera deliciosa",
                genus: "Monstera",
                wateringIntervalDays: 7,
                fertilisingIntervalDays: 28,
                waterGuidance: "Allow the top soil to dry slightly before watering.",
                lightGuidance: "Bright indirect light.",
                fertilisingGuidance: "Fertilise regularly during active growth.",
                repottingGuidance: "Repot when needed."
            ),
            PlantCarePlan(
                species: nil,
                genus: "Monstera",
                wateringIntervalDays: 10,
                fertilisingIntervalDays: 35,
                waterGuidance: "General Monstera watering guidance.",
                lightGuidance: "Bright indirect light.",
                fertilisingGuidance: "General fertilising guidance.",
                repottingGuidance: "Repot when needed."
            )
        ]
        
        let useCase = GetCarePlanUseCase(repository: repository)
        let result = useCase.execute(species: "Monstera deliciosa")
        
        #expect(result?.species == "Monstera deliciosa")
        #expect(result?.wateringIntervalDays == 7)
    }
    
    @Test func getCarePlan_returnsGenusPlan_whenExactSpeciesPlanDoesNotExist() {
        let repository = MockCareRepository()
        repository.carePlans = [
            PlantCarePlan(
                species: nil,
                genus: "Monstera",
                wateringIntervalDays: 7,
                fertilisingIntervalDays: 28,
                waterGuidance: "General Monstera watering guidance.",
                lightGuidance: "Bright indirect light.",
                fertilisingGuidance: "Fertilise during active growth.",
                repottingGuidance: "Repot when needed."
            )
        ]
        
        let useCase = GetCarePlanUseCase(repository: repository)
        let result = useCase.execute(species: "Monstera adansonii")
        
        #expect(result != nil)
        #expect(result?.species == nil)
        #expect(result?.genus == "Monstera")
    }
    
    @Test func getCarePlan_returnsNil_whenNoSpeciesOrGenusPlanExists() {
        let repository = MockCareRepository()
        repository.carePlans = []
        let useCase = GetCarePlanUseCase(repository: repository)
        let result = useCase.execute(species: "Unknown plant")
        
        #expect(result == nil)
    }
    
    @Test func confirmPlantIdentification_usesCarePlanIntervals_whenSpeciesPlanExists() {
        let repository = MockCareRepository()
        repository.carePlans = [
            PlantCarePlan(
                species: "Monstera deliciosa",
                genus: "Monstera",
                wateringIntervalDays: 7,
                fertilisingIntervalDays: 28,
                waterGuidance: "Allow the top soil to dry slightly before watering.",
                lightGuidance: "Bright indirect light.",
                fertilisingGuidance: "Fertilise regularly during active growth.",
                repottingGuidance: "Repot when needed."
            )
        ]
        let useCase = ConfirmPlantIdentificationUseCase(careRepository: repository)
        let imageData = Data([1, 2, 3])
        let plant = useCase.execute(species: "Monstera deliciosa", name: "Monty", imageData: imageData)
        
        #expect(plant.name == "Monty")
        #expect(plant.species == "Monstera deliciosa")
        #expect(plant.wateringIntervalDays == 7)
        #expect(plant.fertilisingIntervalDays == 28)
        #expect(plant.imageData == imageData)
    }
    
    @Test func confirmPlantIdentification_usesDefaultWateringInterval_whenCarePlanDoesNotExist() {
        let repository = MockCareRepository()
        repository.carePlans = []
        let useCase = ConfirmPlantIdentificationUseCase(careRepository: repository)
        let plant = useCase.execute(species: "Unknown plant", name: "Mystery", imageData: Data())
        
        #expect(plant.species == "Unknown plant")
        #expect(plant.wateringIntervalDays == 7)
        #expect(plant.fertilisingIntervalDays == nil)
    }
}
