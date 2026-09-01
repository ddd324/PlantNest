//
//  MyPlantsView.swift
//  PlantNest
//
//  Created by Djy on 01/09/2026.
//

import SwiftUI

struct MyPlantsView: View {
    var body: some View {
        Text("My Plants")
            .navigationTitle("My Plants")
    }
}

#Preview {
    NavigationStack {
        MyPlantsView()
    }
}
