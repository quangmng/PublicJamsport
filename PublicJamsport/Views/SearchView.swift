//
//  SearchView.swift
//  PublicJamsport
//
//  Created by Quang Minh Nguyen on 16/9/2024.
//

import SwiftUI
import MapKit

struct SearchView: View {
    @State private var invokeNearby: Bool = false
    
    var body: some View {
        Map()
            .sheet(isPresented: $invokeNearby, content: {
                Text("Nearby things with search bar")
            })
            .presentationDetents([.height(500),.height(600)])
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
        
    }
}
