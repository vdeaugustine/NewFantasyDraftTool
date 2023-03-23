//
//  ExtPlayerEntity.swift
//  NewFantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/23/23.
//

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
    
    
}
