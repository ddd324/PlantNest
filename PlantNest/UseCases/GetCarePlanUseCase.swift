//
//  GetCarePlanUseCase.swift
//  PlantNest
//
//  Created by Djy on 06/09/2026.
//

import Foundation

struct GetCarePlanUseCase {
    private let repository: CareRepository
    
    init(repository: CareRepository) {
        self.repository = repository
    }
    
    func execute(species: String) -> PlantCarePlan? {
        if let exactPlan = repository.fetchCarePlan(for: species) {
            return exactPlan
        }
        
        let genus = species.split(separator: " ").first.map(String.init)
        
        guard let genus else {
            return nil
        }
        
        return repository.fetchCarePlan(forGenus: genus)
    }
}
