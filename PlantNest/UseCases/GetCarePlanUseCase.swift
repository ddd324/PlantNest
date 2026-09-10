//
//  GetCarePlanUseCase.swift
//  PlantNest
//
//  Created by Djy on 06/09/2026.
//

import Foundation

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
        
        let genus = species.split(separator: " ").first.map(String.init)
        
        guard let genus, let genusPlan = repository.fetchCarePlan(forGenus: genus) else {
            throw GetCarePlanError.carePlanNotFound
        }
        
        return genusPlan
    }
}
