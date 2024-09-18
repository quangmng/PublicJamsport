//
//  SearchBar.swift
//  PublicJamsport
//
//  Created by Quang Minh Nguyen on 17/9/2024.
//

import Foundation
import SwiftUI

var searchBar: some View {
    
    HStack {
        Image(systemName: "magnifyingglass").foregroundColor(.gray)
        TextField("Search", text: $)
            .font(Font.system(size: 21))
    }
    .padding(7)
    .background(Color.searchBarColor)
    .cornerRadius(50)
}

