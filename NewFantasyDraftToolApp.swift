//
//  NewFantasyDraftToolApp.swift
//  NewFantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/23/23.
//

import SwiftUI
import CoreData

@main
struct NewFantasyDraftToolApp: App {
    let persistenceController = PersistenceController.preview
    
    func printAllScoringSettings() {
        let context = persistenceController.container.viewContext
        let fetchRequest: NSFetchRequest<ScoringSettings> = ScoringSettings.fetchRequest()
        
        do {
            let scoringSettings = try context.fetch(fetchRequest)
            print("All ScoringSettings entities:")
            for setting in scoringSettings {
                print("- \(setting.name ?? "Unnamed"): \(setting)")
            }
        } catch {
            print("Error fetching ScoringSettings: \(error.localizedDescription)")
        }
    }


    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onAppear {
                    ScoringSettings.createDefaultScoringSettings(context: persistenceController.container.viewContext)
                    printAllScoringSettings()
                }
        }
    }
}
