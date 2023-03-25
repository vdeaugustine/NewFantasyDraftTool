//
//  BatterStatKeys.swift
//  NewFantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/23/23.
//

import Foundation

enum StatKeys {
    /// An enumeration representing statistical categories in baseball.
    ///
    /// You can create an instance of Batter by initializing it with one of the raw
    /// values defined in the enumeration. Each Batter case represents a unique
    /// statistical category.
    ///
    ///     let homeRuns = Batter.hr
    ///
    /// The Batter enumeration conforms to the CaseIterable protocol, which
    /// allows you to iterate over all of the cases in the enumeration using the
    /// allCases property.
    ///
    ///      for category in Batter.allCases {
    ///         print(category.rawValue)
    ///      }
    ///
    /// The raw value for each Batter case is a string representing the category
    /// it represents.
    ///
    ///     let battingAverage = Batter.avg.rawValue
    ///
    /// Use Batter to represent statistical categories in baseball, and access
    /// their raw values when necessary.
    enum Batter: String, CaseIterable {
        case pa = "PA"
        case ab = "AB"
        case r = "R"
        case h = "H"
        case oneB = "1B"
        case twoB = "2B"
        case threeB = "3B"
        case hr = "HR"
        case rbi = "RBI"
        case bb = "BB"
        case ibb = "IBB"
        case so = "SO"
        case hbp = "HBP"
        case sf = "SF"
        case sh = "SH"
        case gdp = "GDP"
        case sb = "SB"
        case cs = "CS"
        case avg = "AVG"
        case obp = "OBP"
        case slg = "SLG"
        case ops = "OPS"
        case wOBA
        case bbPercentage = "BB%"
        case kPercentage = "K%"
        case bbPerK = "BB/K"
        case iso = "ISO"
        case spd = "Spd"
        case babip = "BABIP"
        case ubr = "UBR"
        case gdpRuns = "GDPRuns"
        case wRC
        case wRAA
        case uzr = "UZR"
        case wBsR
        case baseRunning = "BaseRunning"
        case war = "WAR"
        case off = "Off"
        case def = "Def"
        case wRCPlus = "wRC+"
        case adp = "ADP"
        case position = "Pos"
        case minPosition = "minpos"
        case teamId = "teamid"
        case league = "League"
        case playerName = "PlayerName"
        case playerIds = "playerids"
        
        /// A way to access all the batter strings in the correct order
        static let allArr: [String] = [Batter.pa.rawValue, Batter.ab.rawValue, Batter.r.rawValue, Batter.h.rawValue, Batter.oneB.rawValue, Batter.twoB.rawValue, Batter.threeB.rawValue, Batter.hr.rawValue, Batter.rbi.rawValue, Batter.bb.rawValue,
                                       Batter.ibb.rawValue, Batter.so.rawValue, Batter.hbp.rawValue, Batter.sf.rawValue, Batter.sh.rawValue, Batter.gdp.rawValue, Batter.sb.rawValue, Batter.cs.rawValue, Batter.avg.rawValue, Batter.obp.rawValue,
                                       Batter.slg.rawValue, Batter.ops.rawValue, Batter.wOBA.rawValue, Batter.bbPercentage.rawValue, Batter.kPercentage.rawValue, Batter.bbPerK.rawValue,
                                       Batter.iso.rawValue, Batter.spd.rawValue, Batter.babip.rawValue, Batter.ubr.rawValue, Batter.gdpRuns.rawValue, Batter.wRC.rawValue, Batter.wRAA.rawValue, Batter.uzr.rawValue,
                                       Batter.wBsR.rawValue, Batter.baseRunning.rawValue, Batter.war.rawValue, Batter.off.rawValue, Batter.def.rawValue, Batter.wRCPlus.rawValue, Batter.adp.rawValue,
                                       Batter.position.rawValue, Batter.minPosition.rawValue, Batter.teamId.rawValue, Batter.league.rawValue, Batter.playerName.rawValue,
                                       Batter.playerIds.rawValue]
    }
    
    /// A collection of static constants representing statistical categories for baseball pitchers.
    ///
    /// Use the constants defined in Pitcher to represent statistical categories
    /// for baseball pitchers. The constants are all of type String, with each one
    /// representing a unique statistical category.
    ///
    ///      let wins = Pitcher.w
    ///       let strikeouts = Pitcher.so 
    ///
    /// Use the constants to access statistical categories by name. These constants
    /// can be useful when working with APIs that return statistical data in JSON
    /// format or other non-Swift formats.
    ///
    ///     let jsonData =  {  "wins": 20,  "strikeouts": 300  }.data(using: .utf8)!
    ///     let decoder = JSONDecoder()
    ///     let decodedData = try decoder.decode([String: Int].self, from: jsonData)
    ///     let wins = decodedData[Pitcher.w] ?? 0
    ///     let strikeouts = decodedData[Pitcher.so] ?? 0
    ///
    /// Access Pitcher constants directly to represent statistical categories for
    /// baseball pitchers.
    enum Pitcher {
        static let w = "W"
        static let l = "L"
        static let era = "ERA"
        static let g = "G"
        static let gs = "GS"
        static let sv = "SV"
        static let svo = "SVO"
        static let ip = "IP"
        static let h = "H"
        static let r = "R"
        static let er = "ER"
        static let hr = "HR"
        static let bb = "BB"
        static let ibb = "IBB"
        static let so = "SO"
        static let hbp = "HBP"
        static let wp = "WP"
        static let gbPercentage = "GB%"
        static let ldPercentage = "LD%"
        static let fbPercentage = "FB%"
        static let eraMinus = "ERA-"
        static let fip = "FIP"
        static let xfip = "xFIP"
        static let war = "WAR"
        static let off = "Off"
        static let def = "Def"
        static let playerId = "playerid"
        static let teamId = "teamid"
        static let projectionType = "projection_type"
    }
}
