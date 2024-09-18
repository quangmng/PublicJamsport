//
//  ContentView.swift
//  PublicJamsport
//
//  Created by Quang Minh Nguyen on 4/9/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = StationViewModel()
    var body: some View {
        TabView {
            SavedView(viewModel: viewModel)
            .tabItem {
                Label("Home", systemImage: "house")
            }

            JamsportView()
                .tabItem {
                    Label("Jamsport", systemImage: "bus")
                }
        }
    }
}


struct ContentView_Previews: PreviewProvider{
    static var previews: some View{
        ContentView()
    }
}

