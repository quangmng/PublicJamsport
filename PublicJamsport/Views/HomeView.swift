//
//  HomeView.swift
//  PublicJamsport
//
//  Created by Quang Minh Nguyen on 16/9/2024.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        TabView{
            MapView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            JamsportView()
                .tabItem {
                    Label("Jamsport", systemImage: "bus")
                }
        }
    }
}

struct HomeView_Previews: PreviewProvider{
    static var previews: some View{
        HomeView()
    }
}
