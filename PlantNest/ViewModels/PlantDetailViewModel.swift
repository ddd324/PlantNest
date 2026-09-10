//
//  PlantDetailViewModel.swift
//  PlantNest
//
//  Created by Djy on 06/09/2026.
//

import Foundation
import Combine

final class PlantDetailViewModel: ObservableObject {
    
    @Published var carePlan: PlantCarePlan?
    
    func loadCarePlan(for species: String, repository: CareRepository) {
        let  getCarePlanUseCase = GetCarePlanUseCase(repository: repository)
        do {
            carePlan = try getCarePlanUseCase.execute(species: species)
        } catch {
            carePlan = nil
        }
    }
}
