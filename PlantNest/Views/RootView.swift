//
//  RootView.swift
//  PlantNest
//
//  Created by Djy on 01/09/2026.
//

import SwiftUI

struct RootView: View {
    
    @StateObject private var careRepository = LocalCareRepository()
    @StateObject private var plantViewModel = PlantViewModel()
    
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house.fill") {
                NavigationStack {
                    HomeView()
                }
            }
            
            Tab("My Plants", systemImage: "leaf.fill") {
                NavigationStack {
                    MyPlantsView()
                }
            }
            Tab("Plant Health", systemImage: "heart.text.clipboard.fill") {
                NavigationStack {
                    PlantHealthView()
                }
            }
        }
        .environmentObject(careRepository)
        .environmentObject(plantViewModel)
        .tint(.green)
    }
    
}

#Preview {
    RootView()
}
