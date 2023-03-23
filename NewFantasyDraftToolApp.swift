//
//  NewFantasyDraftToolApp.swift
//  NewFantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/23/23.
//

import SwiftUI

@main
struct NewFantasyDraftToolApp: App {
    let persistenceController = PersistenceController.preview

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
