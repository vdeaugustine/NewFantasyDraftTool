//
//  ExtDraftSettings.swift
//  NewFantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/27/23.
//

import Foundation
import CoreData

extension DraftSettings {
    static func generateDefault(context: NSManagedObjectContext) -> DraftSettings {
        let defaultDraftSettings = DraftSettings(context: context)
        defaultDraftSettings.isSnakeDraft = true
        defaultDraftSettings.numberOfRounds = 30
        defaultDraftSettings.numberOfTeams = 10
        defaultDraftSettings.playersPerTeam = 30
        // Set any other default values for the DraftSettings entity as needed
        
        return defaultDraftSettings
    }

}
