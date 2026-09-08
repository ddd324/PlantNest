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

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }
    
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

}
