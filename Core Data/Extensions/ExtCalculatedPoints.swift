//
//  ExtCalculatedPoints.swift
//  NewFantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/24/23.
//

import CoreData
import Foundation

extension CalculatedPoints {
    /// A method to fetch the associated PlayerEntity object
    /// - Returns optional PlayerEntity object
    func getPlayer() -> PlayerEntity? {
        // Create a new NSFetchRequest object for the PlayerEntity class
        let fetchRequest: NSFetchRequest<PlayerEntity> = PlayerEntity.fetchRequest()
        
        // Ensure that the playerId property is not nil before proceeding
        guard let playerId = playerId else {
            return nil
        }
        
        // Get the managed object context from the CalculatedPoints instance
        guard let context = managedObjectContext else {
            return nil
        }
        
        // Set the predicate for the fetch request to match the playerId
        fetchRequest.predicate = NSPredicate(format: "id == %@", playerId)
        
        do {
            // Execute the fetch request and get the results
            let results = try context.fetch(fetchRequest)
            
            // Return the first object in the results array
            return results.first
            
        } catch {
            // If there was an error, print it and return nil
            print("Error fetching player name: \(error)")
            return nil
        }
    }
    
    /// Convenience initializer to create a new instance of the CalculatedPoints class
    /// - Parameters:
    /// - scoringSettings: The ScoringSettings object to use for scoring calculations
    /// - playerStatsEntity: The PlayerStatsEntity object to use for calculating points
    convenience init(scoringSettings: ScoringSettings, playerStatsEntity: PlayerStatsEntity) {
        // Get the player ID and projection type from the PlayerStatsEntity object
        let playerID = playerStatsEntity.playerids ?? ""
        let projectionType = playerStatsEntity.projectionType ?? ""
        
        // Calculate the points using the scoring settings and player stats
        let bbPoints = scoringSettings.bb * Float(playerStatsEntity.bb)
        let rPoints = scoringSettings.r * Float(playerStatsEntity.r)
        let rbiPoints = scoringSettings.rbi * Float(playerStatsEntity.rbi)
        let sbPoints = scoringSettings.sb * Float(playerStatsEntity.sb)
        let csPoints = scoringSettings.cs * Float(playerStatsEntity.cs)
        let tbPoints = scoringSettings.tb * Float(playerStatsEntity.tb)
        let kPoints = scoringSettings.batterK * Float(playerStatsEntity.so)
        let amount = bbPoints + rPoints + rbiPoints + sbPoints + csPoints + tbPoints + kPoints
        
        // Get the persistence controller instance
        let persistenceController = PersistenceController.preview
        
        // Call the designated initializer on the superclass with the managed object context from the persistence controller
        self.init(context: persistenceController.container.viewContext)
        
        // Set the properties of the instance
        self.amount = amount
        self.playerId = playerID
        self.projectionType = projectionType
        self.scoringName = scoringSettings.name
    }
}
