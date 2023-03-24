//
//  ExtScoringSettings.swift
//  NewFantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/23/23.
//

import CoreData
import Foundation

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
