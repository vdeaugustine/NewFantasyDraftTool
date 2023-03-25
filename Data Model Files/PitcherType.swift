//
//  PitcherType.swift
//  NewFantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/25/23.
//

import Foundation

// MARK: - PitcherType

/// An enumeration representing the two types of baseball pitchers: starters and relievers.
///
/// Use the PitcherType enumeration to represent the two types of baseball pitchers: starters and relievers.
///
/// /// let pitcherType = PitcherType.starter ///
///
/// The enumeration has two cases: .starter and .reliever.
///
/// /// case starter, reliever ///
///
/// Use the .starter case to represent a starting pitcher, and the .reliever case to represent a relief pitcher.
///
/// /// switch self { /// case .starter: /// return "SP" /// case .reliever: /// return "RP" /// } ///
///
/// Use the short property to get a string representing the abbreviated name of the PitcherType.
///
/// /// let pitcherType = PitcherType.starter /// let shortName = pitcherType.short // "SP" ///
///
/// Use the id property to get a string representing the unique identifier of the PitcherType.
///
/// /// let pitcherType = PitcherType.starter /// let id = pitcherType.id // "starter" ///
///
/// Use the str and description properties to get a string representing the full name of the PitcherType.
///
/// /// let pitcherType = PitcherType.starter /// let str = pitcherType.str // "starter" /// let description = pitcherType.description // "starter" ///
enum PitcherType: String, Codable, Hashable, Identifiable, CustomStringConvertible, Equatable {
    case starter, reliever

    /// RP or SP
    var short: String {
        switch self {
            case .starter:
                return "SP"
            case .reliever:
                return "RP"
        }
    }

    var str: String { rawValue }
    var description: String { rawValue }
    var id: String { rawValue }
}
