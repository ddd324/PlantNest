//
//  MyPlantsView.swift
//  PlantNest
//
//  Created by Djy on 01/09/2026.
//

import SwiftUI

struct MyPlantsView: View {
    @StateObject private var plantViewModel = PlantViewModel()
    
    var body: some View {
        List(plantViewModel.plants) { plant in
            NavigationLink {
                PlantDetailView(plant: plant)
            } label: {
                HStack(spacing: 16) {
                    Image(plant.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 70, height: 70)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(plant.name)
                            .font(.headline)
                        
                        Text(plant.species)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        Text("Water every \(plant.wateringIntervalDays) days")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle("My Plants")
        .onAppear{
            plantViewModel.loadPlants()
        }
    }
    
}

#Preview {
    NavigationStack {
        MyPlantsView()
    }
}
