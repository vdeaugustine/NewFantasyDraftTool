//
//  AllScoringSEttingsViews.swift
//  NewFantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/23/23.
//

import CoreData
import SwiftUI
import Vin

// MARK: - AllScoringSettingsViews

/// A SwiftUI view that displays a list of all ScoringSettings objects in Core Data
struct AllScoringSettingsViews: View {
    // Properties
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: ScoringSettings.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \ScoringSettings.name, ascending: true)],
                  animation: .default)
    private var scoringSettings: FetchedResults<ScoringSettings>

    // Body
    var body: some View {
        List {
            ForEach(scoringSettings) { scoringSetting in
                NavigationLink(destination: ScoringSettingsDetailView(scoringSetting: scoringSetting)) {
                    VStack(alignment: .leading) {
                        Text(scoringSetting.name ?? "")
                            .font(.headline)
                    }
                }
            }
            .onDelete { indexSet in
                // Remove the selected scoring settings from Core Data
                indexSet.forEach { index in
                    let scoringSetting = scoringSettings[index]
                    viewContext.delete(scoringSetting)
                    print("Deleted successfully")
                }

                // Save the changes to Core Data
                do {
                    try viewContext.save()
                    print("Saved successfully")
                } catch {
                    print("Error deleting scoring settings: \(error)")
                }
            }
            
        }
        .navigationTitle("Scoring Settings")
        .toolbarAdd {
            CreateNewScoringSettingsView()
        }
    }
}

// MARK: - AllScoringSettingsViews_Previews

struct AllScoringSettingsViews_Previews: PreviewProvider {
    static var previews: some View {
        AllScoringSettingsViews()
    }
}
