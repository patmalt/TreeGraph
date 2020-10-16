//
//  GraphApp.swift
//  Graph
//
//  Created by Patrick Maltagliati on 10/16/20.
//

import SwiftUI

@main
struct GraphApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
