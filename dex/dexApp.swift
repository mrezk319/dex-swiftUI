//
//  dexApp.swift
//  dex
//
//  Created by Muhammed Rezk Rajab on 10/07/2025.
//

import SwiftUI

@main
struct dexApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
