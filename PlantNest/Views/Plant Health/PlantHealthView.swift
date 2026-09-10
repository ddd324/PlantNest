//
//  PlantHealthView.swift
//  PlantNest
//
//  Created by Djy on 05/09/2026.
//

import SwiftUI

struct PlantHealthView: View {
    
    @EnvironmentObject private var plantViewModel: PlantViewModel
    
    var body: some View {
        List {
            Section {
                if plantViewModel.plants.isEmpty {
                    Text("Add a plant first to check its health.")
                        .foregroundStyle(.secondary)
                } else {
                    Text("Select a plant to check its health.")
                }
            }
            
            Section("My Plants") {
                ForEach(plantViewModel.plants) { plant in
                    NavigationLink {
                        PlantHealthQuestionsView(plant: plant)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(plant.name)
                                .font(.headline)
                            Text(plant.species)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle("Plant Health")
        .onAppear {
            plantViewModel.loadPlants()
        }
    }
}

#Preview {
    NavigationStack {
        PlantHealthView()
    }
    .environmentObject(PlantViewModel())
}
