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
    
    @Test func plantViewModel_addPlant_addsAndSavesPlant()  {
        let repository = MockPlantRepository()
        let viewModel = PlantViewModel(repository: repository)
        let plant = Plant(name: "Monty", species: "Monstera deliciosa", imageName: "", lastWateredDate: Date(), wateringIntervalDays: 7)
        viewModel.addPlant(plant)
        
        #expect(viewModel.plants.count == 1)
        #expect(viewModel.plants.first?.name == "Monty")
        #expect(repository.savedPlants.count == 1)
        #expect(repository.savedPlants.first?.id == plant.id)
    }
    
    @Test func plantViewModel_updatePlant_updatesAndSavesPlant() {
        let repository = MockPlantRepository()
        let viewModel = PlantViewModel(repository: repository)
        let plant = Plant(name: "Monty", species: "Monstera deliciosa", imageName: "", lastWateredDate: Date(), wateringIntervalDays: 7)
        viewModel.addPlant(plant)
        
        var updatedPlant = plant
        updatedPlant.name = "Monty Updated"
        updatedPlant.wateringIntervalDays = 10
        viewModel.updatePlant(updatedPlant)
        
        #expect(viewModel.plants.count == 1)
        #expect(viewModel.plants.first?.name == "Monty Updated")
        #expect(viewModel.plants.first?.wateringIntervalDays == 10)
        #expect(repository.savedPlants.count == 1)
        #expect(repository.savedPlants.first?.name == "Monty Updated")
    }
    
    @Test func plantViewModel_deletePlant_removesAndSavesPlant() {
        let repository = MockPlantRepository()
        let viewModel = PlantViewModel(repository: repository)
        let plant = Plant(name: "Monty", species: "Monstera deliciosa", imageName: "", lastWateredDate: Date(), wateringIntervalDays: 7)
        viewModel.addPlant(plant)
        viewModel.deletePlant(plant)
        
        #expect(viewModel.plants.isEmpty)
        #expect(repository.savedPlants.isEmpty)
    }
    
    @Test func plantViewModel_loadPlants_loadsPlantsFromRepository() {
        let repository = MockPlantRepository()
        let plant = Plant(name: "Monty", species: "Monstera deliciosa", imageName: "", lastWateredDate: Date(), wateringIntervalDays: 7)
        repository.plants = [plant]
        
        let viewModel = PlantViewModel(repository: repository)
        viewModel.loadPlants()
        
        #expect(viewModel.plants.count == 1)
        #expect(viewModel.plants.first?.id == plant.id)
        #expect(viewModel.plants.first?.name == "Monty")
    }
    
    @Test func careViewModel_updatePlant_updatesLastWateredDate_whenActivityIsWatering() {
        let viewModel = CareViewModel()
        let originalDate = Date(timeIntervalSince1970: 1_000_000)
        let recordDate = Date(timeIntervalSince1970: 2_000_000)
        let plant = Plant(name: "Monty", species: "Monstera deliciosa", imageName: "", lastWateredDate: originalDate, wateringIntervalDays: 7)
        let record = CareRecord(plantID: plant.id, activityType: .watering, date: recordDate)
        let updatedPlant = viewModel.updatePlant(after: record, originalPlant: plant)
        
        #expect(updatedPlant.lastWateredDate == recordDate)
    }
    
    @Test func careViewModel_updatePlant_updatesLastFertilisedDate_whenActivityIsFertilising() {
        let viewModel = CareViewModel()
        let originalDate = Date(timeIntervalSince1970: 1_000_000)
        let recordDate = Date(timeIntervalSince1970: 2_000_000)
        let plant = Plant(name: "Monty", species: "Monstera deliciosa", imageName: "", lastWateredDate: originalDate, wateringIntervalDays: 7, lastFertilisedDate: nil, fertilisingIntervalDays: 28)
        let record = CareRecord(plantID: plant.id, activityType: .fertilising, date: recordDate)
        let updatedPlant = viewModel.updatePlant(after: record, originalPlant: plant)
        
        #expect(updatedPlant.lastFertilisedDate == recordDate)
        #expect(updatedPlant.lastWateredDate == originalDate)
    }
    
    @Test func careViewModel_selectSoilCondition_updatesRecommendation() {
        let viewModel = CareViewModel()
        let plant = Plant(name: "Monty", species: "Monstera deliciosa", imageName: "", lastWateredDate: Date(), wateringIntervalDays: 7)
        viewModel.selectSoilCondition(.dry, for: plant)
        
        #expect(viewModel.selectedSoilCondition == .dry)
        #expect(viewModel.recommendation?.shouldWater == true)
    }
    
    @Test func careViewModel_selectSoilCondition_doesNotRecommendWatering_whenSoilIsWet() {
        let viewModel = CareViewModel()
        let plant = Plant(name: "Monty", species: "Monstera deliciosa", imageName: "", lastWateredDate: Date(), wateringIntervalDays: 7)
        viewModel.selectSoilCondition(.wet, for: plant)
        
        #expect(viewModel.selectedSoilCondition == .wet)
        #expect(viewModel.recommendation?.shouldWater == false)
    }
    
    @Test func careViewModel_recordWatering_returnsUpdatedPlant_whenRecordIsValid() {
        let repository = MockCareRepository()
        let viewModel = CareViewModel()
        let oldDate = Date(timeIntervalSince1970: 1_000_000)
        let plant = Plant(name: "Monty", species: "Monstera deliciosa", imageName: "", lastWateredDate: oldDate, wateringIntervalDays: 7)
        let updatedPlant = viewModel.recordWatering(for: plant, repository: repository)
        
        #expect(updatedPlant != nil)
        #expect(updatedPlant?.lastWateredDate != oldDate)
        #expect(viewModel.recordMessage == "Watering recorded successfully.")
        #expect(repository.records.count == 1)
    }
    
    @Test func careViewModel_recordWatering_returnsNil_whenWateringAlreadyRecordedToday() throws {
        let repository = MockCareRepository()
        let viewModel = CareViewModel()
        let plant = Plant(name: "Monty", species: "Monstera deliciosa", imageName: "", lastWateredDate: Date(), wateringIntervalDays: 7)
        let existingRecord = CareRecord(plantID: plant.id, activityType: .watering, date: Date())
        
        try repository.addCareRecord(existingRecord)
        
        let updatedPlant = viewModel.recordWatering(for: plant, repository: repository)
        
        #expect(updatedPlant == nil)
        #expect(viewModel.recordMessage == "Watering has already been recorded today.")
    }
    
    @Test func identificationViewModel_selectCandidate_updatesSelectionAndClearsManualSpecies() {
        let viewModel = IdentificationViewModel()
        viewModel.useManualSpecies = true
        viewModel.manualSpecies = "Monstera adansonii"
        
        let candidate = PlantIdentificationCandidate(species: "Monstera deliciosa", confidence: 82)
        viewModel.selectCandidate(candidate)
        
        #expect(viewModel.selectedCandidate?.species == "Monstera deliciosa")
        #expect(viewModel.useManualSpecies == false)
        #expect(viewModel.manualSpecies.isEmpty)
    }
    
    @Test func identificationViewModel_confirmSelection_showsError_whenPlantNameIsMissing() {
        let repository = MockCareRepository()
        let viewModel = IdentificationViewModel()
        let candidate = PlantIdentificationCandidate(species: "Monstera deliciosa", confidence: 82)
        viewModel.selectCandidate(candidate)
        viewModel.confirmSelection(imageData: Data(), careRepository: repository)
        
        #expect(viewModel.confirmedPlant == nil)
        #expect(viewModel.errorMessage == "Please enter a plant name.")
    }
    
    @Test func identificationViewModel_confirmSelection_createsPlant_whenSelectionIsValid() {
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

        let viewModel = IdentificationViewModel()
        let candidate = PlantIdentificationCandidate(species: "Monstera deliciosa", confidence: 82)

        viewModel.plantName = "Monty"
        viewModel.selectCandidate(candidate)
        viewModel.confirmSelection(imageData: Data(), careRepository: repository)

        #expect(viewModel.confirmedPlant != nil)
        #expect(viewModel.confirmedPlant?.name == "Monty")
        #expect(viewModel.confirmedPlant?.species == "Monstera deliciosa")
        #expect(viewModel.confirmedPlant?.wateringIntervalDays == 7)
        #expect(viewModel.errorMessage == nil)
    }
}
