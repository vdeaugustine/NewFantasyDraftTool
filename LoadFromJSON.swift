//
//  LoadFromJSON.swift
//  NewFantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/23/23.
//

import Foundation
import CoreData

extension Int64 {
    
    /// Creates a new `Int64` instance from an optional `String`.
    ///
    /// If the string can be parsed as an integer, the initializer returns a new `Int64` instance
    /// containing the parsed value. If the string is `nil`, the initializer returns `nil`.
    ///
    /// - Parameter string: The string to parse as an integer.
    ///
    /// - Returns: A new `Int64` instance containing the parsed value of `string`, or `nil` if
    ///   `string` could not be parsed as an integer.
    ///
    /// - Note: This initializer uses the `init?(_ text: String, radix: Int = default)` initializer
    ///   provided by `Int64` to parse the string as an integer. If the string cannot be parsed as an
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
func loadBatters(projectionType: ProjectionType, position: Position, context: NSManagedObjectContext) {
    
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
        guard let playerId = Int64(playerData["playerids"] as? String) else { continue }
//        print("Player ID:", playerId)
        // Check if a PlayerEntity with the same playerId already exists
        let fetchRequest: NSFetchRequest<PlayerEntity> = PlayerEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", playerId)
        fetchRequest.fetchLimit = 1
        
        var player: PlayerEntity!
        
        do {
            let fetchedPlayers = try context.fetch(fetchRequest)
            if let existingPlayer = fetchedPlayers.first {
                player = existingPlayer
//                print("Player already existed: ", player.id)
            } else {
                // Create a new PlayerEntity
                player = PlayerEntity(context: context)
                player.id = playerId
                player.name = playerData["PlayerName"] as? String ?? ""
                player.teamShort = playerData["Team"] as? String ?? ""
                player.teamFull = playerData["ShortName"] as? String ?? ""
                print("Player NOT already existed. New player now: ", player.id)
            }
        } catch {
            print("Error fetching player: \(error)")
            continue
        }
        
        // Create a new PlayerStatsEntity
        let stats = PlayerStatsEntity(context: context)
        stats.g = playerData["G"] as? Int64 ?? 0
        stats.ab = playerData["AB"] as? Int64 ?? 0
        stats.pa = playerData["PA"] as? Int64 ?? 0
        stats.h = playerData["H"] as? Int64 ?? 0
        stats.oneB = playerData["1B"] as? Int64 ?? 0
        stats.twoB = playerData["2B"] as? Int64 ?? 0
        stats.threeB = playerData["3B"] as? Int64 ?? 0
        stats.hr = playerData["HR"] as? Int64 ?? 0
        stats.r = playerData["R"] as? Int64 ?? 0
        stats.rbi = playerData["RBI"] as? Int64 ?? 0
        stats.bb = playerData["BB"] as? Int64 ?? 0
        stats.ibb = playerData["IBB"] as? Int64 ?? 0
        stats.so = playerData["SO"] as? Int64 ?? 0
        stats.hbp = playerData["HBP"] as? Int64 ?? 0
        stats.sf = playerData["SF"] as? Int64 ?? 0
        stats.sh = playerData["SH"] as? Int64 ?? 0
        stats.gdp = playerData["GDP"] as? Int64 ?? 0
        stats.sb = playerData["SB"] as? Int64 ?? 0
        stats.cs = playerData["CS"] as? Int64 ?? 0
        stats.avg = playerData["AVG"] as? Double ?? 0
        stats.obp = playerData["OBP"] as? Double ?? 0
        stats.slg = playerData["SLG"] as? Double ?? 0
        stats.ops = playerData["OPS"] as? Double ?? 0
        stats.wOBA = playerData["wOBA"] as? Double ?? 0
        stats.bbPercentage = playerData["BB%"] as? Double ?? 0
        stats.kPercentage = playerData["K%"] as? Double ?? 0
        stats.bbPerK = playerData["BB/K"] as? Double ?? 0
        stats.iso = playerData["ISO"] as? Double ?? 0
        stats.spd = playerData["Spd"] as? Double ?? 0
        stats.babip = playerData["BABIP"] as? Double ?? 0
        stats.ubr = playerData["UBR"] as? Double ?? 0
        stats.gdpRuns = playerData["GDPRuns"] as? Double ?? 0
        stats.wRC = playerData["wRC"] as? Double ?? 0
        stats.wRAA = playerData["wRAA"] as? Double ?? 0
        stats.uzr = playerData["UZR"] as? Double ?? 0
        stats.wBsR = playerData["wBsR"] as? Double ?? 0
        stats.baseRunning = playerData["BaseRunning"] as? Double ?? 0
        stats.war = playerData["WAR"] as? Double ?? 0
        stats.offense = playerData["Off"] as? Double ?? 0
        stats.def = playerData["Def"] as? Double ?? 0
        stats.wRCPlus = playerData["wRC+"] as? Double ?? 0
        stats.adp = playerData["ADP"] as? Double ?? 0
        stats.minpos = playerData["minpos"] as? String ?? ""
        stats.teamid = playerData["teamid"] as? Int64 ?? 0
        stats.League = playerData["League"] as? String ?? ""
        stats.projectionType = projectionType.rawValue
        
        // Add the stats to the player
        player.addToStats(stats)
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
        try context.save()
    } catch {
        print("Error saving context: \(error)")
    }
    
}

extension String {
    mutating func appendIfNotContains(_ string: String?, separator: String = ",") {
        guard let string = string else { return }
        if !self.contains(string) {
            if self.isEmpty {
                self = string
            } else {
                self += "\(separator)\(string)"
            }
        }
    }
}

