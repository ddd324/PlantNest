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
        repository.fetchCarePlan(for: species)
    }
}
