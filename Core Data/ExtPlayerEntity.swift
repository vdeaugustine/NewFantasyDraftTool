//
//  ExtPlayerEntity.swift
//  NewFantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/23/23.
//

import CoreData
import Foundation

extension PlayerEntity {
    /// An array of `PlayerStatsEntity` sorted by projection type.
    ///
    /// This computed property returns an array of player stats entities that are
    /// sorted by their projection type. The `stats` property must be a set of
    /// `PlayerStatsEntity` objects. If `stats` is not a set, an empty array is
    /// returned.
    ///
    /// If two stats entities have the same projection type, they are sorted
    /// alphabetically by player name. If the projection type for any of the
    /// entities is `nil`, it is sorted before the entities with projection types.
    ///
    /// Example usage:
    ///
    /// ```
    /// let stats: [PlayerStatsEntity] = ...
    /// let sortedStats = stats.statsArray
    /// ```

    var statsArray: [PlayerStatsEntity] {
        let set = stats as? Set<PlayerStatsEntity> ?? []
        return set.sorted {
            $0.projectionType ?? "" < $1.projectionType ?? ""
        }
    }

    /// Returns a PlayerStatsEntity object for the specified projection type.
    ///
    /// Provide a ProjectionType parameter to specify the type of projection to return stats for.
    /// The function returns a PlayerStatsEntity object if it exists in statsArray for the specified projection type,
    /// otherwise it returns nil.
    ///
    /// - Parameter projectionType: The type of projection to return stats for.
    ///
    /// - Returns: A PlayerStatsEntity object for the specified projection type, or nil if it doesn't exist in statsArray.
    ///
    /// Usage example:
    ///
    ///     let stats = stats(for: .season2022)
    ///     if let battingAverage = stats?.avg {
    ///       print("Batting average for season 2022: \(battingAverage)")
    ///     }
    ///
    /// - Note: statsArray is an array of PlayerStatsEntity objects containing stats for different projection types.
    func stats(for projectionType: ProjectionType) -> PlayerStatsEntity? {
        statsArray.first(where: { $0.projectionType == projectionType.rawValue })
    }

    /// Returns the value of a specific statistical category for a given projection type.
    ///
    /// Use this function to retrieve the value of a specific statistical category (such as hits, runs, or strikeouts) for a given projection type (such as regular season or playoffs). Pass in the statName parameter as a string representing the desired statistical category, and the projectionType parameter as a string representing the desired projection type. The function returns the value of the requested statistical category as an optional Any type.
    ///
    /// - Parameters:
    /// - statName: A string representing the desired statistical category.
    /// - projectionType: An optional string representing the desired projection type. If nil, the function returns the statistical value for the default projection type.
    /// - Returns: The value of the requested statistical category as an optional Any type. Returns nil if the requested statistical category or projection type does not exist.
    ///
    /// Example usage:
    ///
    ///     if let hits = getStat(for: "H", projectionType: "regularSeason") as? Int {
    ///         print("The player has \(hits) hits in the regular season.") }
    ///     else {
    ///      print("The requested statistical category or projection type does not exist.")
    ///     }
    ///
    /// This function retrieves the value of the H (hits) statistical category for the regularSeason projection type, and prints the number of hits for the player in the regular season. If the requested statistical category or projection type does not exist, the function prints an error message.
    func getStat(for statName: String, projectionType: String?) -> Any? {
        guard let statsSet = stats as? Set<PlayerStatsEntity> else { return nil }
        let stats = statsSet.filter { $0.projectionType == projectionType }
        if stats.isEmpty {
            return nil
        }
        let stat = stats.first!
        switch statName {
            case "AB":
                return stat.ab
            case "BB":
                return stat.bb
            case "CS":
                return stat.cs
            case "G":
                return stat.g
            case "GDP":
                return stat.gdp
            case "H":
                return stat.h
            case "HBP":
                return stat.hbp
            case "HR":
                return stat.hr
            case "IBB":
                return stat.ibb
            case "1B":
                return stat.oneB
            case "PA":
                return stat.pa
            case "R":
                return stat.r
            case "RBI":
                return stat.rbi
            case "SB":
                return stat.sb
            case "SF":
                return stat.sf
            case "SH":
                return stat.sh
            case "SO":
                return stat.so
            case "AVG":
                return stat.avg
            case "OBP":
                return stat.obp
            case "SLG":
                return stat.slg
            case "OPS":
                return stat.ops
            case "wOBA":
                return stat.wOBA
            case "BB%":
                return stat.bbPercentage
            case "K%":
                return stat.kPercentage
            case "BB/K":
                return stat.bbPerK
            case "ISO":
                return stat.iso
            case "Spd":
                return stat.spd
            case "BABIP":
                return stat.babip
            case "UBR":
                return stat.ubr
            case "GDPRuns":
                return stat.gdpRuns
            case "wRC":
                return stat.wRC
            case "wRAA":
                return stat.wRAA
            case "UZR":
                return stat.uzr
            case "wBsR":
                return stat.wBsR
            case "BaseRunning":
                return stat.baseRunning
            case "WAR":
                return stat.war
            case "Off":
                return stat.offense
            case "Def":
                return stat.def
            case "wRC+":
                return stat.wRCPlus
            case "ADP":
                return stat.adp
            case "Pos":
                return stat.Pos
            case "minpos":
                return stat.minpos
            case "teamid":
                return stat.teamid
            case "League":
                return stat.League
            case "PlayerName":
                return stat.playerName
            case "playerids":
                return stat.playerids
            default:
                return nil
        }
    }

    /// Converts a given stat name and projection type into a string representation of the corresponding value. If the value is a Double, it will be returned as a string with two decimal places. If the value is an Int, it will be returned as a string.
    /// - Parameters:
    /// - statName: The name of the stat to retrieve the value for.
    /// - projectionType: The projection type to retrieve the value for.
    /// - Returns: A string representation of the corresponding value for the given stat name and projection type, or nil if no value could be retrieved.
    func getStatStr(for statName: String, projectionType: ProjectionType) -> String? {
        if let asDouble = getStat(for: statName, projectionType: projectionType.rawValue) as? Double {
            return asDouble.formatForBaseball()
        } else if let asInt = getStat(for: statName, projectionType: projectionType.rawValue) as? Int {
            return asInt.str
        }
        return nil
    }

    /// Returns an array of available ProjectionTypes based on the statsArray.
    /// The function first maps the projectionType property of all PlayerStatsEntity objects in statsArray
    /// into an array of String values. It then removes any empty strings and maps the remaining strings
    /// into an array of ProjectionType values using the init?(rawValue:) initializer. The resulting array
    /// contains all the available projection types that have been loaded into statsArray.
    /// - Returns: An array of available ProjectionTypes based on the statsArray.
    var availableProjectionTypes: [ProjectionType] {
        let projectionTypeStrings = statsArray.map { $0.projectionType ?? "" }
        return projectionTypeStrings.compactMap { ProjectionType(rawValue: $0) }
    }

    /// Calculates the fantasy points for the player based on the given scoring settings and projection type.
    /// - Parameters:
    /// - scoringSettings: The ScoringSettings object to use for calculating the fantasy points.
    /// - projectionType: The projection type to use for calculating the fantasy points.
    /// - Returns: The calculated fantasy points as a Double, or nil if the player stats for the given projection type cannot be found.
    func fantasyPoints(scoringSettings: ScoringSettings, projectionType: ProjectionType) -> Double? {
        guard let playerStats = statsArray.first(where: { $0.projectionType == projectionType.rawValue }) else {
            return nil
        }
        let runsPoints = Double(playerStats.r) * scoringSettings.r
        let rbiPoints = Double(playerStats.rbi) * scoringSettings.rbi
        let totalBasesPoints = Double(playerStats.tb) * scoringSettings.tb
        let stolenBasesPoints = Double(playerStats.sb) * scoringSettings.sb
        let walksPoints = Double(playerStats.bb) * scoringSettings.bb
        let caughtStealingPoints = Double(playerStats.cs) * scoringSettings.cs
        let strikeoutsPoints = Double(playerStats.so) * scoringSettings.batterK

        let fantasyPoints = runsPoints + rbiPoints + totalBasesPoints + stolenBasesPoints + walksPoints + caughtStealingPoints + strikeoutsPoints

        return fantasyPoints
    }

    // Check if the context has a PlayerStatsEntity object that has the given projection type
    // Get the player from the PlayerStatsEntity object
    // Check if there is a ScoringSettings object with the name "DefaultPoints" in the context
    func calculateDefaultPointsIfNeeded(projectionType: ProjectionType, mainContext: NSManagedObjectContext) {
            
            // Get the PlayerStatsEntity
            guard let playerStats = statsArray.first(where: { $0.projectionType == projectionType.rawValue }),
                  let player = playerStats.player,
                  let scoringSettings = ScoringSettings.fetchDefaultPointsScoringSettings(in: mainContext) else {
                return
            }
            
            // Check if there is already a CalculatedPoints object with the name "DefaultPoints" for this playerStatsEntity
            guard playerStats.calculatedPoints?.first(where: { ($0 as? CalculatedPoints)?.scoringName == "DefaultPoints" }) == nil else {
                return
            }
            
            // Calculate the fantasy points for this player using the "DefaultPoints" ScoringSettings object
            let fantasyPoints = player.fantasyPoints(scoringSettings: scoringSettings, projectionType: projectionType) ?? 0.0
            
            // Create a new CalculatedPoints object with the calculated points
            let calculatedPoints = CalculatedPoints(context: mainContext)
            calculatedPoints.amount = fantasyPoints
            calculatedPoints.scoringName = "DefaultPoints"
            calculatedPoints.playerStats = playerStats
            
            // Save the calculated points to the main context
            do {
                try mainContext.save()
            } catch {
                print("Error saving calculated points: \(error.localizedDescription)")
            }
        }



    /// Calculates and returns the total fantasy points for a player for a given projection type.
    ///
    /// The function calculates the fantasy points based on a given set of scoring settings for the points, and returns the calculated points. The calculated points are determined based on the player's statistics for a given projection type. If no calculated points entity exists for a given projection type, the function calls the calculateDefaultPointsIfNeeded function to create it.
    ///
    /// - Parameters:
    /// - projectionType: The projection type for which the function will calculate fantasy points.
    /// - context: The managed object context to be used to retrieve the player's statistics and save the calculated points.
    ///
    /// - Returns: An optional Double value representing the total fantasy points for the player for the given projection type, or nil if no statistics exist for the player.
    func calculatedPoints(for projectionType: ProjectionType, in context: NSManagedObjectContext) -> Double? {
            guard let playerStats = stats?.allObjects as? [PlayerStatsEntity] else {
                return nil
            }

            // Find the matching PlayerStatsEntity with the given projectionType
            if let matchingStats = playerStats.first(where: { $0.projectionType == projectionType.rawValue }) {
                if let calculatedPointsSet = matchingStats.calculatedPoints,
                   let calculatedPointsArray = calculatedPointsSet.allObjects as? [CalculatedPoints],
                   let calculatedPoints = calculatedPointsArray.first {
                    // If there's already a CalculatedPoints entity, return its amount
                    return calculatedPoints.amount
                } else {
                    // If no CalculatedPoints entity exists, call the calculateDefaultPointsIfNeeded function
                    calculateDefaultPointsIfNeeded(projectionType: projectionType, mainContext: context)
                    // Now, the CalculatedPoints should be created, return its amount
                    if let calculatedPointsSet = matchingStats.calculatedPoints,
                       let calculatedPointsArray = calculatedPointsSet.allObjects as? [CalculatedPoints],
                       let calculatedPoints = calculatedPointsArray.first {
                        return calculatedPoints.amount
                    }
                }
            }

            return nil
        }
}
