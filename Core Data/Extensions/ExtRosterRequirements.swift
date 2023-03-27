//
//  ExtRosterRequirements.swift
//  NewFantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/27/23.
//

import CoreData
import Foundation

extension RosterRequirements {
    /// Generates a default RosterRequirements object with the given context and draft settings.
    ///
    ///     let context = persistentContainer.viewContext
    ///     let draftSettings = DraftSettings() // assuming you have created a DraftSettings object elsewhere
    ///     let rosterRequirements = RosterRequirements.generateDefault(context: context, draftSettings: draftSettings)
    ///     // Now the rosterRequirements object has the default values set, and can be modified or saved to the context as needed
    ///
    /// - Parameters:
    /// - context: The managed object context to create the RosterRequirements object in.
    /// - draftSettings: The DraftSettings object to associate the RosterRequirements with.
    /// - Returns: A new RosterRequirements object with default minimum player requirements set.
    static func generateDefault(context: NSManagedObjectContext, draftSettings: DraftSettings) -> RosterRequirements {
        let rosterRequirements = RosterRequirements(context: context)
        rosterRequirements.min1B = 1
        rosterRequirements.min2B = 1
        rosterRequirements.min3B = 1
        rosterRequirements.minOF = 3
        rosterRequirements.minRP = 5
        rosterRequirements.minSP = 5
        rosterRequirements.minSS = 1
        rosterRequirements.draftSettings = draftSettings
        return rosterRequirements
    }
}
