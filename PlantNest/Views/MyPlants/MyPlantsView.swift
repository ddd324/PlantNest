//
//  MyPlantsView.swift
//  PlantNest
//
//  Created by Djy on 01/09/2026.
//

import SwiftUI

struct MyPlantsView: View {
    
    @State private var showingAddPlant = false
    @State private var plantToDelete: Plant?
    @State private var showingDeleteConfirmation = false
    
    @EnvironmentObject private var plantViewModel: PlantViewModel
    @EnvironmentObject private var careRepository: LocalCareRepository
    
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
                .swipeActions {
                    Button {
                        plantToDelete = plant
                        showingDeleteConfirmation = true
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    .tint(.red)
                }
            }
        }
        .navigationTitle("My Plants")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showingAddPlant = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddPlant) {
            NavigationStack {
                AddPlantView()
            }
            .environmentObject(plantViewModel)
            .environmentObject(careRepository)
        }
        .onAppear{
            plantViewModel.loadPlants()
        }
        .alert("Delete Plant?", isPresented: $showingDeleteConfirmation, presenting: plantToDelete) { plant in
            Button("Cancel", role: .cancel) {
                plantToDelete = nil
            }
            Button("Delete", role: .destructive) {
                deleteSelectedPlant()
            }
        } message: { plant in
            Text("Are you sure you want to delete \(plant.name)? This will also remove the plant's care history.")
        }
    }
    
    private func deleteSelectedPlant() {
        guard let plant = plantToDelete else {
            return
        }
        
        do {
            try careRepository.deleteCareRecords(for: plant.id)
            plantViewModel.deletePlant(plant)
            plantToDelete = nil
        } catch {
            print("Failed to delete plant: \(error)")
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
