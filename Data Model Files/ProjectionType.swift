//
//  ProjectionType.swift
//  NewFantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/23/23.
//

import Foundation

// MARK: - ProjectionType

/// An enumeration representing different types of projections for baseball players.
///
/// ProjectionType is a String enumeration that conforms to the CaseIterable
/// and Codable protocols. Use the enumeration cases to represent different
/// types of projections for baseball players.
///
///     let steamerProjections = ProjectionType.steamer
///
/// Use the str computed property to get a String representation of each
/// projection type.
///
///     let steamerProjectionsStr = ProjectionType.steamer.str
///
/// Use the title computed property to get a more human-readable String
/// representation of each projection type.
///
///     let steamerProjectionsTitle = ProjectionType.steamer.title
///
/// Use the static batterArr, allArr, and pitcherArr properties to access
/// arrays of ProjectionType cases that are relevant to specific player
/// positions or contexts.
///
///     let batterProjections = ProjectionType.batterArr
///     let allProjections = ProjectionType.allArr
///     let pitcherProjections = ProjectionType.pitcherArr
///
/// Use the various jsonFile, extendedFile, and jsonBatterFileName and
/// jsonPitcherFileName methods to get the names of files containing
/// projections in JSON format, with different file names depending on the
/// context and position of the player.
///
///     let steamerProjectionsFile = ProjectionType.steamer.jsonFile
///     let extendedSteamerFile = ProjectionType.steamer.extendedFile
///     let extendedBatterFileName = ProjectionType.steamer.extendedFileName(position: .firstBase)
///     let extendedPitcherFileName = ProjectionType.steamer.extendedFileName(pitcherType: .starter)
enum ProjectionType: String, CaseIterable, Codable {
    case steamer, zips, thebat, thebatx, atc, depthCharts, myProjections

    /// The most basic form of the string. Essentially raw value
    var str: String {
        switch self {
            case .steamer:
                return "Steamer"
            case .zips:
                return "zips"
            case .thebat:
                return "Thebat"
            case .thebatx:
                return "Thebatx"
            case .atc:
                return "Atc"
            case .depthCharts:
                return "Fangraphsdc"
            case .myProjections:
                return "My Projections"
        }
    }

    /// The way it would read on Fangraphs
    var title: String {
        switch self {
            case .steamer:
                return str
            case .zips:
                return "ZiPS"
            case .thebat:
                return "THE BAT"
            case .thebatx:
                return "THE BAT X"
            case .atc:
                return str.uppercased()
            case .depthCharts:
                return "Depth Charts"
            case .myProjections:
                return str
        }
    }

    static let batterArr: [ProjectionType] = [.steamer, .thebat, .thebatx, .atc, .depthCharts]
    static let allArr: [ProjectionType] = [.steamer, .thebat, .thebatx, .atc, .depthCharts, .myProjections]
    static let pitcherArr: [ProjectionType] = [.steamer, .thebat, .atc, .depthCharts]

    /// Generates the string that would be used to get just the `ProjectionType`Standard (Deprecated)
    var jsonFile: String { "\(rawValue)Standard" }

    /// A computed property that returns a String representing the name of a file containing JSON-formatted extended projections for a baseball player.
    ///
    /// Use the extendedFile computed property to get the name of a file containing JSON-formatted extended projections for a baseball player.
    ///
    /// /// let projectionType = ProjectionType.steamer /// let fileName = projectionType.extendedFile ///
    ///
    /// The extendedFile property returns a String that represents the name of the file containing the relevant projections. The String is composed of the word "Extended" and the jsonFile property, which is the name of the file containing the standard projections.
    ///
    /// /// "Extended" + jsonFile ///
    ///
    /// Use the extendedFile property to get the name of a file containing JSON-formatted extended projections for a baseball player.
    var extendedFile: String { "Extended" + jsonFile }

    /// Returns a String representing the name of a file containing JSON-formatted extended projections for a baseball player with the given Position.
    ///
    /// Use the extendedFileName method to get the name of a file containing JSON-formatted extended projections for a baseball player with the given Position.
    ///
    /// /// let projectionType = ProjectionType.steamer /// let position = Position.firstBase /// let fileName = projectionType.extendedFileName(position: position) ///
    ///
    /// The method takes a Position value as its argument, and returns a String that represents the name of the file containing the relevant projections. The String is composed of the word "Extended", the jsonBatterFileName returned by the jsonBatterFileName method for the given Position and ProjectionType, and the word "Standard".
    ///
    /// /// "Extended" + jsonBatterFileName(position: position) ///
    ///
    /// Use the extendedFileName method to get the name of a file containing JSON-formatted extended projections for a baseball player with the given Position.
    func extendedFileName(position: Position) -> String {
        "Extended" + jsonBatterFileName(position: position)
    }

    /// Returns a String representing the name of a file containing JSON-formatted extended projections for a baseball pitcher with the given PitcherType.
    ///
    /// Use the extendedFileName method to get the name of a file containing JSON-formatted extended projections for a baseball pitcher with the given PitcherType.
    ///
    /// /// let projectionType = ProjectionType.steamer /// let pitcherType = PitcherType.starter /// let fileName = projectionType.extendedFileName(pitcherType: pitcherType) ///
    ///
    /// The method takes a PitcherType value as its argument, and returns a String that represents the name of the file containing the relevant projections. The String is composed of the word "Extended", the jsonPitcherFileName returned by the jsonPitcherFileName method for the given PitcherType, and the word "Standard".
    ///
    /// /// "Extended" + jsonPitcherFileName(type: pitcherType) ///
    ///
    /// Use the extendedFileName method to get the name of a file containing JSON-formatted extended projections for a baseball pitcher with the given PitcherType.
    func extendedFileName(pitcherType: PitcherType) -> String {
        "Extended" + jsonPitcherFileName(type: pitcherType)
    }

    /// Returns a String representing the name of a file containing JSON-formatted projections for a baseball player with the given position and ProjectionType.
    ///
    /// Use the jsonBatterFileName method to get the name of a file containing JSON-formatted projections for a baseball player with the given position and ProjectionType.
    ///
    /// /// let projectionType = ProjectionType.steamer /// let position = Position.firstBase /// let fileName = projectionType.jsonBatterFileName(position: position) ///
    ///
    /// The method takes a Position value as its argument, and returns a String that represents the name of the file containing the relevant projections. The String is composed of the player's position, the word "Bat", the str representation of the ProjectionType, and the word "Standard".
    ///
    /// /// position.str + "Bat" + str + "Standard" ///
    ///
    /// Use the jsonBatterFileName method to get the name of a file containing JSON-formatted projections for a baseball player with the given position and ProjectionType.
    func jsonBatterFileName(position: Position) -> String {
        position.str + "Bat" + str + "Standard"
    }

    /// Returns a String representing the name of a file containing JSON-formatted projections for a baseball pitcher with the given PitcherType.
    ///
    /// Use the jsonPitcherFileName method to get the name of a file containing JSON-formatted projections for a baseball pitcher with the given PitcherType.
    ///
    /// /// let projectionType = ProjectionType.steamer /// let pitcherType = PitcherType.starter /// let fileName = projectionType.jsonPitcherFileName(type: pitcherType) ///
    ///
    /// The method takes a PitcherType value as its argument, and returns a String that represents the name of the file containing the relevant projections. The String is composed of the word "Sta" (if the PitcherType is .starter) or "Rel" (if the PitcherType is .reliever), the str representation of the ProjectionType, and the word "Standard".
    ///
    /// /// switch type { /// case .starter: /// return "Sta" + str + "Standard" /// case .reliever: /// return "Rel" + str + "Standard" /// } ///
    ///
    /// Use the jsonPitcherFileName method to get the name of a file containing JSON-formatted projections for a baseball pitcher with the given PitcherType.
    func jsonPitcherFileName(type: PitcherType) -> String {
        switch type {
            case .starter:
                return "Sta" + str + "Standard"
            case .reliever:
                return "Rel" + str + "Standard"
        }
    }
}
