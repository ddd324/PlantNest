//
//  AddPlantView.swift
//  PlantNest
//
//  Created by Djy on 03/09/2026.
//

import SwiftUI

struct AddPlantView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Form {
            Section {
                Text("How would you like to add your plant?")
                    .font(.headline)
                
                Text("You can identify a plant from a photo or enter the details yourself.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Section("Add Method") {
                NavigationLink {
                    IdentifyPlantView()
                } label: {
                    VStack(alignment: .leading, spacing: 6) {
                        Label("Identify from Photo", systemImage: "camera.viewfinder")
                            .font(.headline)
                        
                        Text("Choose a photo and view possible plant matches.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
                
                NavigationLink {
                    ManualAddPlantView(onPlantAdded: {})
                } label: {
                    VStack(alignment: .leading, spacing: 6) {
                        Label("Add Manually", systemImage: "square.and.pencil")
                            .font(.headline)
                        
                        Text("Enter the plant details yourself.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("Add Plant")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        AddPlantView()
    }
    .environmentObject(PlantViewModel())
    .environmentObject(LocalCareRepository())
}
