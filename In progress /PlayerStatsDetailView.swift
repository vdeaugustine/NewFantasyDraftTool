//
//  PlayerStatsDetailView.swift
//  NewFantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/25/23.
//

import SwiftUI



struct PlayerStatsDetailView: View {
    let playerStats: PlayerStatsEntity
    
    // Format a stat value as a string.
    func formattedStatValue(_ value: Any?) -> String {
        if let intValue = value as? Int64 {
            return String(intValue)
        } else if let doubleValue = value as? Double {
            return doubleValue.formatForBaseball()
        } else if let stringValue = value as? String {
            return stringValue
        }
        
        return "N/A"
    }

    var body: some View {
        List(PlayerStatsEntity.StatKeys.useful) { statKey in
            Text(statKey.rawValue)
                .spacedOut(text: formattedStatValue(playerStats.value(forKey: statKey.rawValue)))
            
        }
        .navigationTitle("Player Stats Details")
        .toolbar {
            ToolbarItem() {
                NavigationLink {
                    EditPlayerStatsView(playerStats: playerStats)
                } label: {
                    Text("Edit")
                }
            }
        }
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
