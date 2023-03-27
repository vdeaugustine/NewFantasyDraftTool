//
//  PlayerStatsDetailView.swift
//  NewFantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/25/23.
//

import SwiftUI

extension Float {
    /// A utility function that formats a numeric value as a string representing a baseball statistic with three decimal places.
    ///
    /// - Returns: A formatted string representation of the numeric value as a baseball statistic.
    ///
    /// This function uses the roundTo(places:) method to round the numeric value to three decimal places, and then formats the rounded value as a string with either three decimal places as an integer or three decimal places using the String(format:) initializer.
    
    /// If the formatted string starts with "0.", and the rounded value is not a whole number, this function returns the string with the leading "0" removed. Otherwise, it returns the formatted string with three decimal places as an integer.
    
    /// The resulting string is then returned as the result of this function.
    public func formatForBaseball() -> String {
        let roundedValue = roundTo(places: 3)
        if roundedValue.truncatingRemainder(dividingBy: 1) == 0 {
            return String(Int(roundedValue))
        }
        let formattedValue = String(format: "%.3f", roundedValue)
        if formattedValue.hasPrefix("0.") {
            return String(formattedValue.dropFirst(1))
        }
        return formattedValue
    }
    
    /// Provides a convenient method for rounding a Double value to a specified number of decimal places.
    /// - Parameter places: The number of decimal places to round to.
    /// - Returns: The rounded Double value.
    public func roundTo(places: Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
}


struct PlayerStatsDetailView: View {
    let playerStats: PlayerStatsEntity
    
    // Format a stat value as a string.
    func formattedStatValue(_ value: Any?) -> String {
        if let intValue = value as? Int16 {
            return String(intValue)
        } else if let FloatValue = value as? Float {
            return FloatValue.formatForBaseball()
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
