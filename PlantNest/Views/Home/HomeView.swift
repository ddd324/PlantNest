//
//  Home.swift
//  PlantNest
//
//  Created by Djy on 01/09/2026.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        List {
            Section("Today's Care") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Monty")
                        .font(.headline)
                    
                    Text("Watering check due today")
                        .foregroundStyle(.secondary)
                    
                    NavigationLink {
                        WateringCheckView()
                    } label: {
                        Text("Check Now")
                    }
                }
                .padding(.vertical, 4)
            }
            
            Section("Upcoming") {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Snake Plant")
                        .font(.headline)
                    
                    Text("Watering check tomorrow")
                        .foregroundStyle(.secondary)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Peace Lily")
                        .font(.headline)
                    
                    Text("Fertilising in 3 days")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle("Home")
    }
}

#Preview {
    NavigationStack{
        HomeView()
    }
}
