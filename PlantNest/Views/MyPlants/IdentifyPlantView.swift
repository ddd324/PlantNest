//
//  IdentifyPlantView.swift
//  PlantNest
//
//  Created by Djy on 07/09/2026.
//

import SwiftUI
import PhotosUI

struct IdentifyPlantView: View {
    
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedImageData: Data?
    
    var body: some View {
        Form {
            Section("Plant Photo") {
                if let selectedImageData, let uiImage = UIImage(data: selectedImageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 250)
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                } else {
                    PhotosPicker(selection: $selectedPhoto, matching: .images) {
                        VStack(spacing: 12) {
                            Image(systemName: "photo")
                                .font(.system(size: 45))
                            
                            Text("Select Photo")
                                .font(.headline)
                            
                            Text("Choose a photo of your plant.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 180)
                    }
                    .buttonStyle(.plain)
                }
                
                if selectedImageData != nil {
                    PhotosPicker(selection: $selectedPhoto, matching: .images) {
                        Label("Change Photo", systemImage: "photo")
                    }
                }
            }
            
            if let selectedImageData {
                Section {
                    NavigationLink {
                        IdentificationResultsView(selectedImageData: selectedImageData, onPlantAdded: {})
                    } label: {
                        Label("Identify Plant", systemImage: "sparkles")
                    }
                }
            }
        }
        .navigationTitle("Identify Plant")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: selectedPhoto) { _, newPhoto in
            Task {
                selectedImageData = try? await newPhoto?.loadTransferable(type: Data.self)
            }
        }
    }
}

#Preview {
    NavigationStack {
        IdentifyPlantView()
    }
    .environmentObject(PlantViewModel())
    .environmentObject(LocalCareRepository())
}
