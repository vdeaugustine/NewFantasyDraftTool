//
//  ExtPlayerStats.swift
//  NewFantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/24/23.
//

import CoreData
import Foundation
import Vin

extension PlayerStatsEntity {
    
    func getCalculatedPointsEntity(forProjectionType projectionType: String) -> CalculatedPoints? {
        guard let playerId = playerids else {
            return nil
        }
        let fetchRequest: NSFetchRequest<CalculatedPoints> = CalculatedPoints.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "playerId == %@ AND projectionType == %@", playerId, projectionType)
        do {
            let result = try managedObjectContext?.fetch(fetchRequest)
            return result?.first
        } catch {
            print("Failed to fetch calculated points entity: \(error)")
            return nil
        }
    }
}
