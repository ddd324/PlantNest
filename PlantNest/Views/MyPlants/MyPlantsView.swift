//
//  MyPlantsView.swift
//  PlantNest
//
//  Created by Djy on 01/09/2026.
//

import SwiftUI

struct MyPlantsView: View {
    
    @EnvironmentObject private var plantViewModel: PlantViewModel
    
    var body: some View {
        List(plantViewModel.plants) { plant in
            NavigationLink {
                PlantDetailView(plant: plant)
            } label: {
                HStack(spacing: 16) {
                    if let imageData = plant.imageData, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 70, height: 70)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    } else if !plant.imageName.isEmpty {
                        Image(plant.imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 70, height: 70)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    } else {
                        Image(systemName: "leaf.fill")
                            .resizable()
                            .scaledToFit()
                            .padding(18)
                            .frame(width: 70, height: 70)
                            .background(.quaternary)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    
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
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    AddPlantView()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .onAppear{
            plantViewModel.loadPlants()
        }
    }
    
}

#Preview {
    NavigationStack {
        MyPlantsView()
    }
    .environmentObject(PlantViewModel())
    .environmentObject(LocalCareRepository())
}
