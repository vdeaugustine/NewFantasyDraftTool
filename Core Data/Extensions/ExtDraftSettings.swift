//
//  ExtDraftSettings.swift
//  NewFantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/27/23.
//

import CoreData
import Foundation

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

    convenience init(context: NSManagedObjectContext,
                     isSnakeDraft: Bool? = nil,
                     numberOfRounds: Int16? = nil,
                     numberOfTeams: Int16? = nil,
                     playersPerTeam: Int16? = nil,
                     rosterRequirements: RosterRequirements? = nil,
                     scoringSystems: ScoringSettings? = nil) {
        self.init(context: context)

        if let isSnakeDraft = isSnakeDraft {
            self.isSnakeDraft = isSnakeDraft
        }

        if let numberOfRounds = numberOfRounds {
            self.numberOfRounds = numberOfRounds
        }

        if let numberOfTeams = numberOfTeams {
            self.numberOfTeams = numberOfTeams
        }

        if let playersPerTeam = playersPerTeam {
            self.playersPerTeam = playersPerTeam
        }

        if let rosterRequirements = rosterRequirements {
            self.rosterRequirements = rosterRequirements
        }

        if let scoringSystems = scoringSystems {
            self.scoringSystems = scoringSystems
        }
    }
}
