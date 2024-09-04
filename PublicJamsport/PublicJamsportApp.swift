//
//  PublicJamsportApp.swift
//  PublicJamsport
//
//  Created by Quang Minh Nguyen on 4/9/2024.
//

import SwiftUI

@main
struct PublicJamsportApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
