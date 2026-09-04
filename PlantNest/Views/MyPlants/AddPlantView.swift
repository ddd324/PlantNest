//
//  AddPlantView.swift
//  PlantNest
//
//  Created by Djy on 03/09/2026.
//

import SwiftUI
import PhotosUI

struct AddPlantView: View {
    
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
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                } else {
                    ContentUnavailableView("No Photo Selected", systemImage: "photo",description: Text("Choose a photo of your plant."))
                }
                
                PhotosPicker(selection: $selectedPhoto, matching: .images) {
                    Label("Select Photo", systemImage: "photo.on.rectangle")
                }
            }
            
            if selectedImageData != nil {
                Section {
                    NavigationLink {
                        if let selectedImageData {
                            IdentificationResultsView(selectedImageData: selectedImageData)
                        }
                    } label: {
                        Label("Identify Plant", systemImage: "sparkles")
                    }
                }
            }
            
            Section("Enter Manually") {
                Button("Enter plant information") {
                    //
                }
            }
        }
        .navigationTitle("Add Plant")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: selectedPhoto) {
            Task {
                selectedImageData = try? await selectedPhoto?.loadTransferable(type: Data.self)
            }
        }
    }
}

#Preview {
    NavigationStack {
        AddPlantView()
    }
    .environmentObject(PlantViewModel())
}
