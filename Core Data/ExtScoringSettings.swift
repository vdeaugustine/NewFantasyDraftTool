//
//  ExtScoringSettings.swift
//  NewFantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/23/23.
//

import CoreData
import Foundation
import Combine

// MARK: - CalculatingLoadingManager

//class CalculatingLoadingManager: ObservableObject {
//    @Published var progress: Double = 0
//
//    static var shared = CalculatingLoadingManager()
//}

// Define a class called CalculatingLoadingManager that conforms to the ObservableObject protocol
class CalculatingLoadingManager: ObservableObject {
    // Create a shared instance of the class (singleton pattern) to be used throughout the application
    static let shared = CalculatingLoadingManager()
    
    // A set to store the Combine framework's cancellable instances to manage their lifetimes
    private var cancellables = Set<AnyCancellable>()
    
    // Define a @Published property called progress of type Double, which is initialized to 0.0
    // When this property is updated, SwiftUI will automatically update the UI
    @Published var progress: Double = 0.0
    
    // Create a PassthroughSubject instance of type Double and Never, which can be used to send progress values
    private let progressSubject = PassthroughSubject<Double, Never>()
    
    // The private initializer for the class
    private init() {
        // Connect the progressSubject to the progress property using the Combine framework
        progressSubject
            // Ensure that the updates are received on the main queue (thread)
            .receive(on: DispatchQueue.main)
            // Assign the received values to the progress property
            .assign(to: &$progress)
    }
    
    // Define a function called updateProgress that takes a Double value as a parameter
    func updateProgress(_ value: Double) {
        // Send the value using the progressSubject, which will update the progress property and the UI
        progressSubject.send(value)
    }
}


// MARK: - Wrappers

extension ScoringSettings {
    // This function calculates points for all players in the database and updates the progress using the provided loadingManager
    func calculatePointsForAllPlayers(context: NSManagedObjectContext, _ loadingManager: CalculatingLoadingManager, completion: @escaping ([CalculatedPoints]) -> Void) {
//        // Get the view context from the persistence controller
//        let context = PersistenceController.preview.container.viewContext
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
            
            // Iterate through each PlayerStatsEntity object
            for playerStatsEntity in playerStatsEntities {
                // Create a fetch request for CalculatedPoints objects
                let calculatedPointsFetchRequest: NSFetchRequest<CalculatedPoints> = CalculatedPoints.fetchRequest()

                // Get the playerId and projectionType from the PlayerStatsEntity object
                guard let playerId = playerStatsEntity.playerids,
                      let projectionType = playerStatsEntity.projectionType else {
                    continue // Skip this iteration if either playerId or projectionType is missing
                }
                
                // Set the fetch request predicate to filter by playerId, projectionType, and scoringName
                calculatedPointsFetchRequest.predicate = NSPredicate(format: "playerId == %@ AND projectionType == %@ AND scoringName == %@", playerId, projectionType, self.name!)


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

                // Try to save the context with the new CalculatedPoints object
                do {
                    try context.save()
                } catch {
                    // Log any errors that occur during saving
                    print("Error saving calculated points: \(error)")
                }
            }
            
            // Call the completion handler with the array of calculated points
            completion(calculatedPointsArray)

        } catch {
            // Log any errors that occur during fetching player stats entities
            print("Error fetching player stats entities: \(error)")
        }
    }


    static func isDuplicateName(name: String) -> Bool {
        let context: NSManagedObjectContext
        context = PersistenceController.preview.container.viewContext

        let fetchRequest: NSFetchRequest<ScoringSettings> = ScoringSettings.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Error counting ScoringSettings entities: \(error.localizedDescription)")
            return true
        }
    }

    static var defaultScoring: ScoringSettings {
        let context = PersistenceController.preview.container.viewContext

        if let found = fetchDefaultPointsScoringSettings(in: context) {
            return found
        }

        createDefaultScoringSettings(context: context)

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
}

extension ScoringSettings {
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
