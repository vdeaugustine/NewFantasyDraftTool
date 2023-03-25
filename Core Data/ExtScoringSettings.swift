//
//  ExtScoringSettings.swift
//  NewFantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/23/23.
//

import CoreData
import Foundation

// MARK: - CalculatingLoadingManager

class CalculatingLoadingManager: ObservableObject {
    @Published var progress: Double = 0

    static var shared = CalculatingLoadingManager()
}

// MARK: - Wrappers

extension ScoringSettings {
    func calculatePointsForAllPlayers(_ loadingManager: CalculatingLoadingManager, completion: @escaping ([CalculatedPoints]) -> Void) {
        let context = PersistenceController.preview.container.viewContext
        let playerStatsFetchRequest: NSFetchRequest<PlayerStatsEntity> = PlayerStatsEntity.fetchRequest()
        do {
            let playerStatsEntities = try context.fetch(playerStatsFetchRequest)
            var calculatedPointsArray = [CalculatedPoints]()
            let count = playerStatsEntities.count
            let progressInc: Double = 1 / Double(count)
            for playerStatsEntity in playerStatsEntities {
                let calculatedPointsFetchRequest: NSFetchRequest<CalculatedPoints> = CalculatedPoints.fetchRequest()

                guard let playerId = playerStatsEntity.playerids,
                      let projectionType = playerStatsEntity.projectionType else {
                    continue
                }
                calculatedPointsFetchRequest.predicate = NSPredicate(format: "playerId == %@ AND projectionType == %@", playerId, projectionType)

                let count = try context.count(for: calculatedPointsFetchRequest)
                if count > 0 {
                    continue
                }
                let calculatedPoints = CalculatedPoints(scoringSettings: self, playerStatsEntity: playerStatsEntity)
                calculatedPointsArray.append(calculatedPoints)
//                DispatchQueue.main.async {
                loadingManager.progress += progressInc
//                }

                do {
                    try context.save()

                } catch {
                    
                }
                
            }
            completion(calculatedPointsArray)

        } catch {
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
