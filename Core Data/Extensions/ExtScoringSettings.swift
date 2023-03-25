//
//  ExtScoringSettings.swift
//  NewFantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/23/23.
//

import CoreData
import Foundation

// MARK: - Wrappers

extension ScoringSettings {
    /// Calculates the fantasy points for all players based on the current ScoringSettings.
    ///
    /// - Parameters:
    /// - context: The NSManagedObjectContext in which to execute the calculations.
    /// - loadingManager: The CalculatingLoadingManager to use for progress tracking.
    /// - completion: The closure to execute after the calculations are complete.
    ///
    /// This method fetches all PlayerStatsEntity objects from the context and iterates over them, creating a new CalculatedPoints object for each player who does not already have a CalculatedPoints object for the current ScoringSettings. The method also tracks progress using the loadingManager and executes the completion closure when the calculations are complete.
    ///
    /// If an error occurs while fetching PlayerStatsEntity objects or saving CalculatedPoints objects, the method logs an error message to the console.
    func calculatePointsForAllPlayers(context: NSManagedObjectContext,
                                      _ loadingManager: CalculatingLoadingManager,
                                      completion: @escaping () -> Void) {
        // Create a fetch request for PlayerStatsEntity objects
        let playerStatsFetchRequest: NSFetchRequest<PlayerStatsEntity> = PlayerStatsEntity.fetchRequest()

        do {
            // Fetch all PlayerStatsEntity objects from the context
            let playerStatsEntities = try context.fetch(playerStatsFetchRequest)
            // Initialize an empty array to store the calculated points
            var calculatedPointsArray = [CalculatedPoints]()
            // Get the count of PlayerStatsEntity objects
            let count = playerStatsEntities.count
            // Calculate the progress increment value based on the number of players
            let progressInc: Double = 1 / Double(count)
            let totalCount = playerStatsEntities.count
            print("total count", totalCount)
            print("Number of juan sotos", PlayerStatsEntity.count(for: "Mike Trout", in: context))
            // Iterate through each PlayerStatsEntity object
            for playerStatsEntity in playerStatsEntities {
                // Create a fetch request for CalculatedPoints objects
                let calculatedPointsFetchRequest: NSFetchRequest<CalculatedPoints> = CalculatedPoints.fetchRequest()

                // Get the playerId and projectionType from the PlayerStatsEntity object
                guard let playerId = playerStatsEntity.playerids,
                      let projectionType = playerStatsEntity.projectionType else {
                    continue // Skip this iteration if either playerId or projectionType is missing
                }

                guard let name = name else { continue }
                // Set the fetch request predicate to filter by playerId, projectionType, and scoringName
                calculatedPointsFetchRequest.predicate = NSPredicate(format: "playerId == %@ AND projectionType == %@ AND scoringName == %@", playerId, projectionType, name)

                // Check if there are already any CalculatedPoints objects for the given playerId and projectionType
                let count = try context.count(for: calculatedPointsFetchRequest)
                if count > 0 {
                    continue // Skip this iteration if there are already CalculatedPoints objects for the given playerId and projectionType
                }

                // Create a new CalculatedPoints object using the current ScoringSettings and PlayerStatsEntity
                let calculatedPoints = CalculatedPoints(scoringSettings: self, playerStatsEntity: playerStatsEntity)
                // Add the new CalculatedPoints object to the array
                calculatedPointsArray.append(calculatedPoints)
                // Insert the calculatedPoints object into the viewContext
                context.insert(calculatedPoints)

                // Update the progress using the loadingManager's updateProgress method
                loadingManager.updateProgress(loadingManager.progress + progressInc)
                loadingManager.updateName("\(totalCount)")
//                if let playerName = calculatedPoints.getPlayer()?.name {
//                    loadingManager.updateName(playerName)
//                }
                // Try to save the context with the new CalculatedPoints object
                do {
                    try context.save()
                } catch {
                    // Log any errors that occur during saving
                    print("Error saving calculated points: \(error)")
                }
            }

            // Call the completion handler
            completion()
            loadingManager.reset()

        } catch {
            // Log any errors that occur during fetching player stats entities
            print("Error fetching player stats entities: \(error)")
        }
    }

    /// Determines if there is a ScoringSettings entity with the given name.
    ///
    /// This method creates a fetch request to get all ScoringSettings entities that match the given name. If the count of entities returned by the request is greater than 0, then the name is considered a duplicate and the method returns true. If there are no entities returned or if an error occurs during the fetch request, the method returns false.
    ///
    /// - Parameter name: The name to check for duplicates.
    /// - Returns: A boolean value indicating whether the name is a duplicate.
    static func isDuplicateName(name: String) -> Bool {
        // Get the view context from the shared persistence controller's preview container
        let context: NSManagedObjectContext = PersistenceController.preview.container.viewContext

        // Create a fetch request to get all ScoringSettings entities that match the given name
        let fetchRequest: NSFetchRequest<ScoringSettings> = ScoringSettings.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)

        do {
            // Get the count of entities returned by the fetch request
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            // If an error occurs during the fetch request, log the error and return true to be safe
            print("Error counting ScoringSettings entities: \(error.localizedDescription)")
            return true
        }
    }

    /// A computed property that returns the default ScoringSettings.
    ///
    /// This method first attempts to fetch the default ScoringSettings from the context. If the default ScoringSettings is not found, a new default ScoringSettings is created using createDefaultScoringSettings(context:) method and saved to the context. Finally, the method returns the default ScoringSettings.
    ///
    /// - Returns: The default ScoringSettings.
    static var defaultScoring: ScoringSettings {
        // Get the view context from the shared preview PersistenceController
        let context = PersistenceController.preview.container.viewContext

        // Try to fetch the default `ScoringSettings` from the context
        if let found = fetchDefaultPointsScoringSettings(in: context) {
            return found
        }

        // If the default `ScoringSettings` is not found, create a new default `ScoringSettings` and save it to the context
        createDefaultScoringSettings(context: context)

        // Finally, return the default `ScoringSettings`
        return fetchDefaultPointsScoringSettings(in: context)!
    }

    /// Returns a count of the ScoringSettings objects saved in data.
    static func count(context: NSManagedObjectContext) -> Int {
        let request: NSFetchRequest<ScoringSettings> = ScoringSettings.fetchRequest()
        do {
            let count = try context.count(for: request)
            return count
        } catch {
            print("Error fetching ScoringSettings entities: \(error.localizedDescription)")
            return 0
        }
    }

    /// Fetches the ScoringSettings object with the name "DefaultPoints" from the given context.
    /// - Parameter context: The NSManagedObjectContext to fetch from.
    /// - Returns: The ScoringSettings object with the name "DefaultPoints", if it exists; otherwise, nil.
    static func fetchDefaultPointsScoringSettings(in context: NSManagedObjectContext) -> ScoringSettings? {
        let request: NSFetchRequest<ScoringSettings> = ScoringSettings.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", "DefaultPoints")
        request.fetchLimit = 1

        do {
            let results = try context.fetch(request)
            return results.first
        } catch {
            print("Error fetching DefaultPoints scoring settings: \(error.localizedDescription)")
            return nil
        }
    }

    /// Creates a default scoring settings entity in Core Data if it doesn't already exist.
    /// - Parameter context: The `NSManagedObjectContext` to create and save the scoring settings entity in.
    static func createDefaultScoringSettings(context: NSManagedObjectContext) {
        let request = NSFetchRequest<ScoringSettings>(entityName: "ScoringSettings")
        request.predicate = NSPredicate(format: "name == %@", "DefaultPoints")

        do {
            let existingSettings = try context.fetch(request)
            if existingSettings.count > 0 {
                // DefaultPoints already exists, so exit the function
                print("DefaultPoints already exists, so exit the function")
                return
            }

            // DefaultPoints doesn't exist, so create and save it
            context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            let scoringSettings = ScoringSettings(context: context)
            scoringSettings.name = "DefaultPoints"
            scoringSettings.tb = 1
            scoringSettings.r = 1
            scoringSettings.rbi = 1
            scoringSettings.sb = 1
            scoringSettings.cs = -1
            scoringSettings.bb = 1
            scoringSettings.batterK = -1
            scoringSettings.wins = 5
            scoringSettings.losses = -3
            scoringSettings.saves = 3
            scoringSettings.er = -1
            scoringSettings.pitcherK = 1
            scoringSettings.ip = 1
            scoringSettings.hitsAllowed = -1
            scoringSettings.walksAllowed = -1
            scoringSettings.qs = 3

            try context.save()
            print("Default scoring settings created and saved.")
        } catch {
            print("Error saving default scoring settings: \(error.localizedDescription)")
        }
    }
}
