//
//  PlantDetailView.swift
//  PlantNest
//
//  Created by Djy on 01/09/2026.
//

import SwiftUI
import PhotosUI

struct PlantDetailView: View {
    
    @State private var plant: Plant
    
    @EnvironmentObject private var careRepository: LocalCareRepository
    @StateObject private var plantDetailViewModel = PlantDetailViewModel()
    @EnvironmentObject private var plantViewModel: PlantViewModel
    
    @State private var selectedPhoto: PhotosPickerItem?
    
    init(plant: Plant) {
        self.plant = plant
    }
    
    private var nextWateringDate: Date? {
        Calendar.current.date(
            byAdding: .day,
            value: plant.wateringIntervalDays,
            to: plant.lastWateredDate
        )
    }
    
    private var nextFertilisingDate: Date? {
        guard let lastFertilisedDate = plant.lastFertilisedDate,
              let fertilisingIntervalDays = plant.fertilisingIntervalDays
        else {
            return nil
        }

        return Calendar.current.date(
            byAdding: .day,
            value: fertilisingIntervalDays,
            to: lastFertilisedDate
        )
    }
    
    var body: some View {
        List {
            Section {
                if let imageData = plant.imageData, let uiImage = UIImage(data: imageData) {
                    VStack(spacing: 12) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .frame(height: 220)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        
                        PhotosPicker(selection: $selectedPhoto, matching: .images) {
                            Label("Change Photo", systemImage: "photo")
                        }
                    }
                } else if !plant.imageName.isEmpty {
                    VStack(spacing: 12) {
                        Image(plant.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .frame(height: 220)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        
                        PhotosPicker(selection: $selectedPhoto, matching: .images) {
                            Label("Change Photo", systemImage: "photo")
                        }
                    }
                } else {
                    PhotosPicker(selection: $selectedPhoto, matching: .images) {
                        VStack(spacing: 12) {
                            Image(systemName: "leaf.fill")
                                .font(.system(size: 55))
                            
                            Label("Add Photo", systemImage: "photo.badge.plus")
                                .font(.headline)
                        }
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 220)
                        .background(.quaternary)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .buttonStyle(.plain)
                }
            }
            
            Section("Plant Information") {
                LabeledContent("Name", value: plant.name)
                LabeledContent("Species", value: plant.species)
            }
            
            if let carePlan = plantDetailViewModel.carePlan {
                Section("Care Plan") {
                    LabeledContent("Water", value: carePlan.waterGuidance)
                    LabeledContent("Light", value: carePlan.lightGuidance)
                    LabeledContent("Fertilising", value: carePlan.fertilisingGuidance)
                    LabeledContent("Repotting", value: carePlan.repottingGuidance)
                }
            }
            
            Section("Care Schedule") {
                LabeledContent("Watering", value: "Every \(plant.wateringIntervalDays) days")
                                
                if let nextWateringDate {
                    LabeledContent(
                        "Next watering check",
                        value: nextWateringDate.formatted(
                            date: .abbreviated,
                            time: .omitted
                        )
                    )
                }
                
                if let fertilisingIntervalDays = plant.fertilisingIntervalDays {
                    LabeledContent("Fertilising", value: "Every \(fertilisingIntervalDays) days")
                }
                
                if let nextFertilisingDate {
                    LabeledContent(
                        "Next fertilising",
                        value: nextFertilisingDate.formatted(
                            date: .abbreviated,
                            time: .omitted
                        )
                    )
                }
            }
            
            Section("Plant Health") {
                NavigationLink {
                    PlantHealthQuestionsView(
                        plant: plant
                    )
                } label: {
                    Label(
                        "Check Plant Health",
                        systemImage: "heart.text.square"
                    )
                }
            }
            
            Section("History") {
                NavigationLink {
                    CareHistoryView(plant: plant)
                } label: {
                    Label("Care History", systemImage: "clock.arrow.circlepath")
                }
                
                NavigationLink {
                    AddCareRecordView(plant: plant)
                } label: {
                    Label("Add Care Record", systemImage: "plus.circle")
                }
            }
        }
        .navigationTitle(plant.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            plantDetailViewModel.loadCarePlan(for: plant.species, repository: careRepository)
        }
        .onChange(of: selectedPhoto) { _, newPhoto in
            Task {
                guard let imageData = try? await newPhoto?.loadTransferable(type: Data.self) else {
                    return
                }
                
                var updatedPlant = plant
                updatedPlant.imageData = imageData
                plant = updatedPlant
                plantViewModel.updatePlant(updatedPlant)
            }
        }
    }
}

#Preview {
    NavigationStack {
        PlantDetailView(plant: Plant(
            name: "Monty",
            species: "Monstera deliciosa",
            imageName: "monstera",
            lastWateredDate: Date(),
            wateringIntervalDays: 7
        ))
    }
    .environmentObject(LocalCareRepository())
}
