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
    /// Retrieves the CalculatedPoints object for a given projection type.
    ///
    /// - Parameters:
    ///     - projectionType: The projection type to retrieve the CalculatedPoints object for.
    /// - Returns: The CalculatedPoints object for the given projection type, or `nil` if it cannot be found.
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

    /// Returns the count of PlayerStatsEntity objects with a given name in the specified managed object context.
    ///
    /// - Parameters:
    /// - name: The name to search for in the PlayerStatsEntity objects.
    /// - context: The managed object context to perform the search in.
    /// - Returns: The count of PlayerStatsEntity objects with the specified name in the given managed object context. If there is an error fetching the count, it returns 0.
    class func count(for name: String, in context: NSManagedObjectContext) -> Int {
        let fetchRequest: NSFetchRequest<PlayerStatsEntity> = PlayerStatsEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "playerName == %@", name)
        do {
            let count = try context.count(for: fetchRequest)
            return count
        } catch {
            print("Error fetching count: \(error)")
            return 0
        }
    }

    /// Contains every stat that PlayerStatsEntity keeps track of. They are all written with the correct capitalization so simply using rawValue will get the value you are looking for
    /// It is meant to be used for fetching stats
    /// You can also just call it without raw value and get its string since it is CustomStringConvertable
    enum StatKeys: String, CaseIterable, CustomStringConvertible, Identifiable, Codable, Hashable {
        var id: String { self.rawValue }
        
        case ab, adp, avg, babip, baseRunning, bb, bbPercentage, bbPerK, cs, def, g, gdp, gdpRuns, h, hbp, hr, ibb, iso, kPercentage, league, minpos, obp, offense, oneB, ops, pa, playerids, playerName, pos, projectionType, r, rbi, sb, sf, sh, slg, so, spd, tb, teamid, threeB, twoB, ubr, uzr, war, wBsR, wOBA, wRAA, wRC, wRCPlus

        var description: String { rawValue }
        
        static let useful: [PlayerStatsEntity.StatKeys] = [  ab, adp, avg, babip, baseRunning, bb, bbPercentage, bbPerK, cs, def, g, gdp, gdpRuns, h, hbp, hr, ibb, iso, kPercentage, obp, offense, oneB, ops, pa, r, rbi, sb, sf, sh, slg, so, spd, tb, threeB, twoB, ubr, uzr, war, wBsR, wOBA, wRAA, wRC, wRCPlus ]
    }

    func attributeName(for statKey: StatKeys) -> String {
        return statKey.rawValue
    }

    /// Returns a NSFetchRequest for PlayerStatsEntity that filters by projectionType and sorts by the given statKey.
    ///
    /// - Parameters:
    /// - projectionType: The ProjectionType to filter by.
    /// - sortBy:     The StatKeys to sort by.
    /// - Returns: A NSFetchRequest for PlayerStatsEntity that filters by projectionType and sorts by statKey.
    static func fetchRequestForProjectionType(projectionType: ProjectionType, sortBy statKey: StatKeys) -> NSFetchRequest<PlayerStatsEntity> {
        let request: NSFetchRequest<PlayerStatsEntity> = PlayerStatsEntity.fetchRequest()
        request.predicate = NSPredicate(format: "projectionType == %@", projectionType.rawValue)
        request.sortDescriptors = [NSSortDescriptor(key: statKey.rawValue, ascending: false)]
        return request
    }
}
