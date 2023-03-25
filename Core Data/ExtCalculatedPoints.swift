//
//  ExtCalculatedPoints.swift
//  NewFantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/24/23.
//

import CoreData
import Foundation

extension CalculatedPoints {
    func getPlayer() -> PlayerEntity? {
        let fetchRequest: NSFetchRequest<PlayerEntity> = PlayerEntity.fetchRequest()
        guard let playerId = playerId else {
            return nil
        }
        guard let context = managedObjectContext else {
            return nil
        }
        fetchRequest.predicate = NSPredicate(format: "id == %@", playerId)
        do {
            let results = try context.fetch(fetchRequest)
            return results.first
        } catch {
            print("Error fetching player name: \(error)")
            return nil
        }
    }

    convenience init(scoringSettings: ScoringSettings, playerStatsEntity: PlayerStatsEntity) {
        let playerID = playerStatsEntity.playerids ?? ""
        let projectionType = playerStatsEntity.projectionType ?? ""

        let bbPoints = scoringSettings.bb * Double(playerStatsEntity.bb)
        let rPoints = scoringSettings.r * Double(playerStatsEntity.r)
        let rbiPoints = scoringSettings.rbi * Double(playerStatsEntity.rbi)
        let sbPoints = scoringSettings.sb * Double(playerStatsEntity.sb)
        let csPoints = scoringSettings.cs * Double(playerStatsEntity.cs)
        let tbPoints = scoringSettings.tb * Double(playerStatsEntity.tb)
        let kPoints = scoringSettings.batterK * Double(playerStatsEntity.so)
        let amount = bbPoints + rPoints + rbiPoints + sbPoints + csPoints + tbPoints + kPoints

        let persistenceController = PersistenceController.preview

        self.init(context: persistenceController.container.viewContext)
        self.amount = amount
        self.playerId = playerID
        self.projectionType = projectionType
        self.scoringName = scoringSettings.name
        self.playerStats = playerStatsEntity
    }
}
