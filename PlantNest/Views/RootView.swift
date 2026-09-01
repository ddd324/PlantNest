//
//  RootView.swift
//  PlantNest
//
//  Created by Djy on 01/09/2026.
//

import SwiftUI

struct RootView: View {
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
        }
        .tint(.green)
    }
    
}

#Preview {
    RootView()
}
