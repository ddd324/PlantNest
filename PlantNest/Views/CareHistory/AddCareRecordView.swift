//
//  AddCareRecordView.swift
//  PlantNest
//
//  Created by Djy on 03/09/2026.
//

import SwiftUI

struct AddCareRecordView: View {
    
    let plant: Plant

    @EnvironmentObject private var careRepository: LocalCareRepository
    @EnvironmentObject private var plantViewModel: PlantViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedActivity: CareActivityType
    @State private var selectedDate = Date()
    @State private var message: String?
    
    init(plant: Plant, initialActivity: CareActivityType = .watering) {
        self.plant = plant
        _selectedActivity = State(initialValue: initialActivity)
    }
    
    var body: some View {
        Form {
            Section("Plant") {
                Text(plant.name)
            }
            
            Section("Care Activity") {
                Picker("Activity", selection: $selectedActivity) {
                    ForEach(CareActivityType.allCases, id: \.self) { activity in
                        Text(activity.rawValue)
                            .tag(activity)
                    }
                }
            }
            
            Section("Date") {
                DatePicker("Date", selection: $selectedDate, in: ...Date(), displayedComponents: .date)
            }
            
            Section {
                Button("Save Care Record") {
                    saveCareRecord()
                }
            }
            
            if let message {
                Section {
                    Text(message)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle("Add Care Record")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func saveCareRecord() {
        let useCase = RecordCareActivityUseCase(repository: careRepository)
        
        do {
            let record = try useCase.execute(plant: plant, activityType: selectedActivity, date: selectedDate)
            
            var updatedPlant = plant
            
            switch selectedActivity {
            case .watering:
                updatedPlant.lastWateredDate = record.date
            case .fertilising:
                updatedPlant.lastFertilisedDate = record.date
            case .repotting:
                break
            case .pruning:
                break
            }
            
            plantViewModel.updatePlant(updatedPlant)
            dismiss()
        } catch RecordCareActivityUseCase.RecordCareActivityError.futureDate {
            message = "The care date cannot be in the future."
        } catch RecordCareActivityUseCase.RecordCareActivityError.duplicateRecord {
            message = "\(selectedActivity.rawValue) has already been recorded for this date."
        } catch {
            message = "The care record could not be saved. Please try again."
        }
    }
}

#Preview {
    NavigationStack {
        AddCareRecordView(
            plant: Plant(
                name: "Monty",
                species: "Monstera deliciosa",
                imageName: "",
                lastWateredDate: Date(),
                wateringIntervalDays: 7,
                lastFertilisedDate: Date(),
                fertilisingIntervalDays: 28
            )
        )
    }
    .environmentObject(LocalCareRepository())
    .environmentObject(PlantViewModel())
}
