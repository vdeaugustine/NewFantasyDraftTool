//
//  LoadFromJSON.swift
//  NewFantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/23/23.
//

import Foundation
import CoreData

extension Int64 {
    init?(_ string: String?) {
        guard let string = string else { return nil }
        guard let value = Int64(string) else { return nil }
        self = value
    }
}


func loadData(from jsonFile: String, projectionType: ProjectionType, context: NSManagedObjectContext) {
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
        print("Player ID:", playerId)
        // Check if a PlayerEntity with the same playerId already exists
        let fetchRequest: NSFetchRequest<PlayerEntity> = PlayerEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", playerId)
        fetchRequest.fetchLimit = 1
        
        var player: PlayerEntity!
        
        do {
            let fetchedPlayers = try context.fetch(fetchRequest)
            if let existingPlayer = fetchedPlayers.first {
                player = existingPlayer
                print("Player already existed: ", player.id)
            } else {
                // Create a new PlayerEntity
                player = PlayerEntity(context: context)
                player.id = playerId
                player.name = playerData["Name"] as? String ?? ""
                player.position = playerData["position"] as? String ?? ""
                player.team = playerData["Team"] as? String ?? ""
                player.shortName = playerData["ShortName"] as? String ?? ""
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
        stats.projectionType = projectionType.rawValue
        
        // Add the stats to the player
        player.addToStats(stats)
    }
    
    // Save the context
    do {
        try context.save()
    } catch {
        print("Error saving context: \(error)")
    }
    
}
