//
//  ScoringSettingsDetailView.swift
//  NewFantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/24/23.
//

import CoreData
import SwiftUI
import Vin

// MARK: - ScoringSettingsDetailView

struct ScoringSettingsDetailView: View {
    var scoringSetting: ScoringSettings

    var body: some View {
        List {
            Section("Batter") {
                Text("TB").spacedOut(text: scoringSetting.tb.simpleStr())
                Text("R").spacedOut(text: scoringSetting.r.simpleStr())
                Text("RBI").spacedOut(text: scoringSetting.rbi.simpleStr())
                Text("SB").spacedOut(text: scoringSetting.sb.simpleStr())
                Text("CS").spacedOut(text: scoringSetting.cs.simpleStr())
                Text("BB").spacedOut(text: scoringSetting.bb.simpleStr())
                Text("Batter K").spacedOut(text: scoringSetting.batterK.simpleStr())
                Text("Wins").spacedOut(text: scoringSetting.wins.simpleStr())
            }
            Section("Pitcher") {
                Text("Losses").spacedOut(text: scoringSetting.losses.simpleStr())
                Text("Saves").spacedOut(text: scoringSetting.saves.simpleStr())
                Text("Earned Runs").spacedOut(text: scoringSetting.er.simpleStr())
                Text("Pitcher K").spacedOut(text: scoringSetting.pitcherK.simpleStr())
                Text("Innings Pitched").spacedOut(text: scoringSetting.ip.simpleStr())
                Text("Hits Allowed").spacedOut(text: scoringSetting.hitsAllowed.simpleStr())
                Text("Walks Allowed").spacedOut(text: scoringSetting.walksAllowed.simpleStr())
                Text("Quality Starts").spacedOut(text: scoringSetting.qs.simpleStr())
            }
        }

        .navigationTitle(scoringSetting.name ?? "")
    }
}

// MARK: - ScoringSettingsDetailView_Previews

struct ScoringSettingsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ScoringSettingsDetailView(scoringSetting: .defaultScoring)
        }
    }
}
