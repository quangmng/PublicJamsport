//
//  SavedView.swift
//  PublicJamsport
//
//  Created by Quang Minh Nguyen on 18/9/2024.
//

import SwiftUI

struct SavedView: View {
    @State private var showSavedList = false
    @ObservedObject var viewModel: StationViewModel
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        ZStack {
            // MapView to show the saved stations on the map
            MapView(stations: $viewModel.stations, viewModel: viewModel, region: $viewModel.defaultSyd)
                .ignoresSafeArea(edges: .top)

            // Button to show the saved list sheet
            VStack {
                Spacer()
                Button(action: {
                    showSavedList.toggle()
                }) {
                    Text("Show Saved Stations")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
        .sheet(isPresented: $showSavedList) {
            // Show SavedListView in a sheet with presentationDetent
            NavigationView {
                SavedListView(savedStations: .constant(viewModel.convertedSavedStations), unsaveAction: { station in
                    viewModel.unsaveStation(station, context: viewContext)
                })
            }
            .presentationDetents([.medium, .large]) // Allow half and full screen
        }
    }
}


