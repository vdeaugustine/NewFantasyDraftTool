//
//  AllScoringSEttingsViews.swift
//  NewFantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/23/23.
//

import SwiftUI
import CoreData

struct AllScoringSEttingsViews: View {
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

struct ScoringSettingsDetailView: View {
    var scoringSetting: ScoringSettings
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Points Per Stat")
                .font(.headline)
            List {
                Group {
                    Text("TB: \(scoringSetting.tb)")
                    Text("R: \(scoringSetting.r)")
                    Text("RBI: \(scoringSetting.rbi)")
                    Text("SB: \(scoringSetting.sb)")
                    Text("CS: \(scoringSetting.cs)")
                    Text("BB: \(scoringSetting.bb)")
                    Text("Batter K: \(scoringSetting.batterK)")
                    Text("Wins: \(scoringSetting.wins)")
                }
                Group {
                    Text("Losses: \(scoringSetting.losses)")
                    Text("Saves: \(scoringSetting.saves)")
                    Text("Earned Runs: \(scoringSetting.er)")
                    Text("Pitcher K: \(scoringSetting.pitcherK)")
                    Text("Innings Pitched: \(scoringSetting.ip)")
                    Text("Hits Allowed: \(scoringSetting.hitsAllowed)")
                    Text("Walks Allowed: \(scoringSetting.walksAllowed)")
                    Text("Quality Starts: \(scoringSetting.qs)")
                }
            }
            Spacer()
        }
        .padding()
        .navigationTitle(scoringSetting.name ?? "")
    }
}

struct AllScoringSEttingsViews_Previews: PreviewProvider {
    static var previews: some View {
        AllScoringSEttingsViews()
    }
}
