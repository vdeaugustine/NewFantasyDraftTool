//
//  AllScoringSEttingsViews.swift
//  NewFantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/23/23.
//

import SwiftUI
import CoreData
import Vin


struct AllScoringSettingsViews: View {
    @Environment(\.managedObjectContext) private var viewContext
        @FetchRequest(entity: ScoringSettings.entity(),
                      sortDescriptors: [NSSortDescriptor(keyPath: \ScoringSettings.name, ascending: true)],
                      animation: .default)
        private var scoringSettings: FetchedResults<ScoringSettings>
        
        var body: some View {
            NavigationView {
                List {
                    ForEach(scoringSettings) { scoringSetting in
                        NavigationLink(destination: ScoringSettingsDetailView(scoringSetting: scoringSetting)) {
                            VStack(alignment: .leading) {
                                Text(scoringSetting.name ?? "")
                                    .font(.headline)
                            }
                        }
                    }
                }
                .navigationTitle("Scoring Settings")
            }
        }
}



struct AllScoringSettingsViews_Previews: PreviewProvider {
    static var previews: some View {
        AllScoringSettingsViews()
    }
}
