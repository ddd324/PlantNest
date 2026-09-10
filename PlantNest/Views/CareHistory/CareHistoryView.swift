//
//  CareHistoryView.swift
//  PlantNest
//
//  Created by Djy on 02/09/2026.
//

import SwiftUI

struct CareHistoryView: View {
    
    let plant: Plant
    
    @EnvironmentObject private var careRepository: LocalCareRepository
    @State private var records: [CareRecord] = []
    @State private var errorMessage: String?
    
    var body: some View {
        List {
            if let errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.secondary)
            } else if records.isEmpty {
                Text("No care records yet.")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(records) { record in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(record.activityType.rawValue)
                            .font(.headline)
                        
                        Text(record.date.formatted(date: .abbreviated, time: .omitted))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .navigationTitle("Care History")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadCareRecords()
        }
    }
    
    private func loadCareRecords() {
        do {
            records = try careRepository.fetchCareRecords(for: plant.id)
                .sorted { $0.date > $1.date}
            errorMessage = nil
        } catch {
            errorMessage = "Care history could not be loaded. Please try again."
        }
    }
}

#Preview {
    NavigationStack {
        CareHistoryView(
            plant: Plant(
                name: "Monty",
                species: "Monstera deliciosa",
                imageName: "monstera",
                lastWateredDate: Date(),
                wateringIntervalDays: 7
            )
        )
    }
    .environmentObject(LocalCareRepository())
}
