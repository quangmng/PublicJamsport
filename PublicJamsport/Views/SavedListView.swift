//
//  SavedListView.swift
//  PublicJamsport
//
//  Created by Quang Minh Nguyen on 18/9/2024.
//

import SwiftUI

struct SavedListView: View {
    @Binding var savedStations: [Station]
    var unsaveAction: (Station) -> Void

    var body: some View {
        List {
            ForEach(savedStations) { station in
                VStack(alignment: .leading) {
                    Text(station.name)
                        .font(.headline)
                    Text("Latitude: \(station.latitude), Longitude: \(station.longitude)")
                        .font(.subheadline)
                }
            }
//            .onDelete(perform: unsave) // Enable swipe to unsave
        }
        .navigationTitle("Saved Stations")
//        .toolbar {
//            EditButton()
//        }
    }

    // Function to handle unsaving
    private func unsave(at offsets: IndexSet) {
        offsets.map { savedStations[$0] }.forEach { station in
            unsaveAction(station)
        }
    }
}
