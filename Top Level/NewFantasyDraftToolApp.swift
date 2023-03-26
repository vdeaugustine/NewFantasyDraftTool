//
//  NewFantasyDraftToolApp.swift
//  NewFantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/23/23.
//

import CoreData
import SwiftUI

/// The main entry point for the NewFantasyDraftTool app
@main
struct NewFantasyDraftToolApp: App {
    // Properties
#if DEBUG
    let persistenceController = PersistenceController.preview
#else
    let persistenceController = PersistenceController.shared
#endif
    
    // A function to print all ScoringSettings entities in Core Data
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
    
    @State private var showSplash = true
    
    // Body
    var body: some Scene {
        WindowGroup {
            if showSplash {
                VStack {
                    Color.red
                }.ignoresSafeArea().frame(maxWidth: .infinity, maxHeight: .infinity)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                        withAnimation {
                            showSplash = false
                        }
                    }
                }
            }
            else {
                ContentView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .onAppear {
                        // When the app appears, create the default scoring settings and print all scoring settings in Core Data
                        
                        ScoringSettings.createDefaultScoringSettings(context: persistenceController.container.viewContext)
    //                    printAllScoringSettings()
                    }
                
            }
        }
    }
}
