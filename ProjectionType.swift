//
//  ProjectionType.swift
//  NewFantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/23/23.
//

import Foundation

// MARK: - ProjectionTypes

// enum ProjectionType: String, CaseIterable {
//    case ATC
//    case Steamer
//    case theBat
//    case theBatx
//    case depthCharts
//    case zips
// }

enum ProjectionType: String, CaseIterable, Codable {
    case steamer, zips, thebat, thebatx, atc, depthCharts, myProjections

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

    var jsonFile: String { "\(rawValue)Standard" }

    var extendedFile: String { "Extended" + jsonFile }

    func extendedFileName(position: Position) -> String {
        "Extended" + jsonBatterFileName(position: position)
    }

    func extendedFileName(pitcherType: PitcherType) -> String {
        "Extended" + jsonPitcherFileName(type: pitcherType)
    }

    func jsonBatterFileName(position: Position) -> String {
        position.str + "Bat" + str + "Standard"
    }

    func jsonPitcherFileName(type: PitcherType) -> String {
        switch type {
            case .starter:
                return "Sta" + str + "Standard"
            case .reliever:
                return "Rel" + str + "Standard"
        }
    }
}

// MARK: - Position

enum Position: Codable {
    case c, first, second, third, ss, of, dh, sp, rp

    /// Positions are returned in such a way that they can be used for accessing files names. (ie. 1B is 1b and SS is Ss)
    var str: String {
        switch self {
            case .c:
                return "C"
            case .first:
                return "1b"
            case .second:
                return "2b"
            case .third:
                return "3b"
            case .ss:
                return "Ss"
            case .of:
                return "Of"
            case .dh:
                return "DH"
            case .sp:
                return "SP"
            case .rp:
                return "RP"
        }
    }

    static let batters: [Position] =
        [Position.c,
         Position.first,
         Position.second,
         Position.third,
         Position.ss,
         Position.of]
}

// MARK: - PitcherType

enum PitcherType: String, Codable, Hashable, Identifiable, CustomStringConvertible, Equatable {
    case starter, reliever

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
