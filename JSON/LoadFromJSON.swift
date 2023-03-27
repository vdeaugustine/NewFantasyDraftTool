//
//  LoadFromJSON.swift
//  NewFantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/23/23.
//

import CoreData
import Foundation

extension Int16 {
    /// Creates a new `Int16` instance from an optional `String`.
    ///
    /// If the string can be parsed as an integer, the initializer returns a new `Int16` instance
    /// containing the parsed value. If the string is `nil`, the initializer returns `nil`.
    ///
    /// - Parameter string: The string to parse as an integer.
    ///
    /// - Returns: A new `Int16` instance containing the parsed value of `string`, or `nil` if
    ///   `string` could not be parsed as an integer.
    ///
    /// - Note: This initializer uses the `init?(_ text: String, radix: Int = default)` initializer
    ///   provided by `Int16` to parse the string as an integer. If the string cannot be parsed as an
    ///   integer, the initializer returns `nil`.
    init?(_ string: String?) {
        guard let string = string else { return nil }
        self.init(string, radix: 10)
    }
}

/// Loads batter stats from a JSON file for the given projection type and position into the specified managed object context.
///
/// - Parameters:
/// - projectionType: The projection type for the stats to load.
/// - position: The position for the stats to load.
/// - context: The managed object context to load the stats into.
func loadBatters(projectionType: ProjectionType, position: Position, container: NSPersistentContainer) {
    let context = container.viewContext
    let jsonFile = projectionType.extendedFileName(position: position)

    // Load the JSON data from the file
    guard let url = Bundle.main.url(forResource: jsonFile, withExtension: "json"),
          let data = try? Data(contentsOf: url) else {
        print("Error loading JSON file")
        return
    }

    // Decode the JSON data into an array of dictionaries
    guard let decodedData = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
        print("Error decoding JSON data")
        return
    }

    // Process each dictionary in the decoded data
    for playerData in decodedData {
        guard let playerId = playerData["playerids"] as? String else { continue }

        // Check if a PlayerEntity with the same playerId already exists
        let playerFetchRequest: NSFetchRequest<PlayerEntity> = PlayerEntity.fetchRequest()
        playerFetchRequest.predicate = NSPredicate(format: "id == %d", playerId)
        playerFetchRequest.fetchLimit = 1

        var player: PlayerEntity!

        do {
            let fetchedPlayers = try context.fetch(playerFetchRequest)
            if let existingPlayer = fetchedPlayers.first {
                player = existingPlayer
            } else {
                // Create a new PlayerEntity
                player = PlayerEntity(context: context)
                player.id = "\(playerId)"
                player.name = playerData["PlayerName"] as? String ?? ""
                player.teamShort = playerData["Team"] as? String ?? ""
                player.teamFull = playerData["ShortName"] as? String ?? ""
            }
        } catch {
            print("Error fetching player: \(error)")
            continue
        }

        // Check if a PlayerStatsEntity with the same playerId and projectionType already exists
        let statsFetchRequest: NSFetchRequest<PlayerStatsEntity> = PlayerStatsEntity.fetchRequest()
        statsFetchRequest.predicate = NSPredicate(format: "playerids == %@ AND projectionType == %@", playerId, projectionType.rawValue)
        statsFetchRequest.fetchLimit = 1

        do {
            let fetchedStats = try context.fetch(statsFetchRequest)
            if fetchedStats.first != nil {
                // Skip this iteration since a PlayerStatsEntity with the same playerId and projectionType already exists
                continue
            }
        } catch {
            print("Error fetching player stats: \(error)")
            continue
        }

        // Create a new PlayerStatsEntity
        let stats = PlayerStatsEntity(context: context)
        stats.playerids = "\(playerId)"
        stats.g = playerData["G"] as? Int16 ?? 0
        stats.ab = playerData["AB"] as? Int16 ?? 0
        stats.pa = playerData["PA"] as? Int16 ?? 0
        stats.h = playerData["H"] as? Int16 ?? 0
        stats.oneB = playerData["1B"] as? Int16 ?? 0
        stats.twoB = playerData["2B"] as? Int16 ?? 0
        stats.threeB = playerData["3B"] as? Int16 ?? 0
        stats.hr = playerData["HR"] as? Int16 ?? 0
        stats.r = playerData["R"] as? Int16 ?? 0
        stats.rbi = playerData["RBI"] as? Int16 ?? 0
        stats.bb = playerData["BB"] as? Int16 ?? 0
        stats.ibb = playerData["IBB"] as? Int16 ?? 0
        stats.so = playerData["SO"] as? Int16 ?? 0
        stats.hbp = playerData["HBP"] as? Int16 ?? 0
        stats.sf = playerData["SF"] as? Int16 ?? 0
        stats.sh = playerData["SH"] as? Int16 ?? 0
        stats.gdp = playerData["GDP"] as? Int16 ?? 0
        stats.sb = playerData["SB"] as? Int16 ?? 0
        stats.cs = playerData["CS"] as? Int16 ?? 0
        stats.avg = playerData["AVG"] as? Float ?? 0
        stats.obp = playerData["OBP"] as? Float ?? 0
        stats.slg = playerData["SLG"] as? Float ?? 0
        stats.ops = playerData["OPS"] as? Float ?? 0
        stats.wOBA = playerData["wOBA"] as? Float ?? 0
        stats.bbPercentage = playerData["BB%"] as? Float ?? 0
        stats.kPercentage = playerData["K%"] as? Float ?? 0
        stats.bbPerK = playerData["BB/K"] as? Float ?? 0
        stats.iso = playerData["ISO"] as? Float ?? 0
        stats.spd = playerData["Spd"] as? Float ?? 0
        stats.babip = playerData["BABIP"] as? Float ?? 0
        stats.ubr = playerData["UBR"] as? Float ?? 0
        stats.gdpRuns = playerData["GDPRuns"] as? Float ?? 0
        stats.wRC = playerData["wRC"] as? Float ?? 0
        stats.wRAA = playerData["wRAA"] as? Float ?? 0
        stats.uzr = playerData["UZR"] as? Float ?? 0
        stats.wBsR = playerData["wBsR"] as? Float ?? 0
        stats.baseRunning = playerData["BaseRunning"] as? Float ?? 0
        stats.war = playerData["WAR"] as? Float ?? 0
        stats.offense = playerData["Off"] as? Float ?? 0
        stats.def = playerData["Def"] as? Float ?? 0
        stats.wRCPlus = playerData["wRC+"] as? Float ?? 0
        stats.adp = playerData["ADP"] as? Float ?? 0
        stats.minpos = playerData["minpos"] as? String ?? ""
        stats.teamid = playerData["teamid"] as? Int16 ?? 0
        stats.League = playerData["League"] as? String ?? ""
        stats.projectionType = projectionType.rawValue
        stats.playerName = playerData["PlayerName"] as? String ?? ""

        let singles = stats.h - stats.twoB - stats.threeB - stats.hr
        let tb = singles + (stats.twoB * 2) + (stats.threeB * 3) + (stats.hr * 4)
        stats.tb = tb

        // Add the stats to the player
        player.addToStats(stats)

        // Calculate default points for the player
        //        player.calculateDefaultPointsIfNeeded(projectionType: projectionType, mainContext: container.viewContext)

        var oldPos = player.position
        if oldPos != nil {
            oldPos?.appendIfNotContains(stats.minpos, separator: ", ")
        } else {
            oldPos = stats.minpos
        }
        player.position = oldPos
    }

    // Save the context
    do {
        try container.viewContext.save()
    } catch {
        print("Error saving context: \(error)")
    }
}

extension String {
    mutating func appendIfNotContains(_ string: String?, separator: String = ",") {
        guard let string = string else { return }
        if !contains(string) {
            if isEmpty {
                self = string
            } else {
                self += "\(separator)\(string)"
            }
        }
    }
}
