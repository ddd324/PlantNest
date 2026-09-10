//
//  GetCarePlanUseCase.swift
//  PlantNest
//
//  Created by Djy on 06/09/2026.
//

import Foundation

/// Finds care guidance for a plant using an exact species match or genus fallback.
struct GetCarePlanUseCase {
    
    enum GetCarePlanError: Error {
        case carePlanNotFound
    }
    
    private let repository: CareRepository
    
    init(repository: CareRepository) {
        self.repository = repository
    }
    
    func execute(species: String) throws -> PlantCarePlan {
        if let exactPlan = repository.fetchCarePlan(for: species) {
            return exactPlan
        }
        
        // Fall back to genus-level guidance when no exact species plan is available.
        let genus = species.split(separator: " ").first.map(String.init)
        
        guard let genus, let genusPlan = repository.fetchCarePlan(forGenus: genus) else {
            throw GetCarePlanError.carePlanNotFound
        }
        
        return genusPlan
    }
}
