//
//  PlayerStatsDetailView.swift
//  NewFantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/25/23.
//

import SwiftUI


struct PlayerStatsDetailView: View {
    let playerStats: PlayerStatsEntity

    var body: some View {
        List(PlayerStatsEntity.StatKeys.useful) { statKey in
            Text(statKey.rawValue)
                .spacedOut(text: playerStats.value(forKey: statKey.rawValue) as? String ?? "" )
            
        }
        .navigationTitle("Player Stats Details")
    }
}

struct PlayerStatsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let playerStats = PlayerStatsEntity(context: PersistenceController.preview.container.viewContext)
        playerStats.playerName = "Sample Player"
        playerStats.projectionType = "Sample Projection"
        playerStats.ab = 100
        playerStats.adp = 10.0
        // Add the rest of the stats here in a similar format

        return PlayerStatsDetailView(playerStats: playerStats)
            .previewDevice("iPhone 12 Pro Max")
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
