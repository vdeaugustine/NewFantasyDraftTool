//
//  EditPlayerStatsView.swift
//  NewFantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/26/23.
//

import CoreData
import SwiftUI
import Vin

// MARK: - EditPlayerStatsView

struct EditPlayerStatsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    let playerStats: PlayerStatsEntity
    @State private var editedStats: [PlayerStatsEntity.StatKeys: Double] = [:]
    @State private var selectedStat: PlayerStatsEntity.StatKeys?
    @State private var alertText = ""
    @State private var selectedValue: Int = 0
    @State private var showAlert: Bool = false
    @State private var editedValue: Int = 0

    @State private var ab: Int
    @State private var bb: Int
    @State private var g: Int
    @State private var h: Int
    @State private var hbp: Int
    @State private var hr: Int
    @State private var ibb: Int
    @State private var oneB: Int
    @State private var pa: Int
    @State private var r: Int
    @State private var rbi: Int
    @State private var sb: Int
    @State private var sf: Int
    @State private var so: Int
    @State private var tb: Int
    @State private var threeB: Int
    @State private var twoB: Int

    init(playerStats: PlayerStatsEntity) {
        self.playerStats = playerStats

        _ab = State(initialValue: Int(playerStats.ab))
        _bb = State(initialValue: Int(playerStats.bb))
        _g = State(initialValue: Int(playerStats.g))
        _h = State(initialValue: Int(playerStats.h))
        _hbp = State(initialValue: Int(playerStats.hbp))
        _hr = State(initialValue: Int(playerStats.hr))
        _ibb = State(initialValue: Int(playerStats.ibb))
        _oneB = State(initialValue: Int(playerStats.oneB))
        _pa = State(initialValue: Int(playerStats.pa))
        _r = State(initialValue: Int(playerStats.r))
        _rbi = State(initialValue: Int(playerStats.rbi))
        _sb = State(initialValue: Int(playerStats.sb))
        _sf = State(initialValue: Int(playerStats.sf))
        _so = State(initialValue: Int(playerStats.so))
        _tb = State(initialValue: Int(playerStats.tb))
        _threeB = State(initialValue: Int(playerStats.threeB))
        _twoB = State(initialValue: Int(playerStats.twoB))
    }

    // Format a stat value as a string.
    func formattedStatValue(_ value: Any?) -> String {
        if let intValue = value as? Int64 {
            return String(intValue)
        } else if let doubleValue = value as? Double {
            return doubleValue.formatForBaseball()
        } else if let stringValue = value as? String {
            return stringValue
        }

        return "N/A"
    }

    func value(forKey key: PlayerStatsEntity.StatKeys) -> String {
        if let edited = editedStats[key] {
            return edited.formatForBaseball()
        } else if let existing = playerStats.value(forKey: key.rawValue) as? Double {
            return existing.formatForBaseball()
        }
        return "N/A"
    }

    var body: some View {
        List(PlayerStatsEntity.StatKeys.useful) { statKey in
            Button(action: {
                if let stateProp = self.stateProperty(for: statKey) {
                    self.selectedStat = statKey
                    self.editedValue = stateProp
                    self.showAlert = true
                }
            }) {
                
                if self.stateProperty(for: statKey) != nil {
                    Text(statKey.rawValue)
                        .spacedOut(text: value(forKey: statKey))
                        .foregroundColor(.blue)
                } else {
                    Text(statKey.rawValue)
                        .spacedOut(text: value(forKey: statKey))
                }
            }
            .buttonStyle(.plain)
        }
        .navigationTitle("Edit Player Stats")
        
        .intAlert(showAlert: $showAlert,
                  value: $editedValue,
                  title: selectedStat?.rawValue,
                  completion: { success in
                      if success, let statKey = selectedStat {
                          editedStats[statKey] = Double(editedValue)
                      }
                      selectedStat = nil
                  })
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    saveEditedStats()
                }
            }
        }
    }

    private func stateProperty(for statKey: PlayerStatsEntity.StatKeys) -> Int? {
        switch statKey {
            case .ab: return ab
            case .bb: return bb
            case .g: return g
            case .h: return h
            case .hbp: return hbp
            case .hr: return hr
            case .ibb: return ibb
            case .oneB: return oneB
            case .pa: return pa
            case .r: return r
            case .rbi: return rbi
            case .sb: return sb
            case .sf: return sf
            case .so: return so
            case .tb: return tb
            case .threeB: return threeB
            case .twoB: return twoB
            default: return nil
        }
    }

    private func updateStateProperty(for statKey: PlayerStatsEntity.StatKeys, with value: String) {
        guard let intValue = Int(value) else { return }
        switch statKey {
            case .ab: ab = intValue
            case .bb: bb = intValue
            case .g: g = intValue
            case .h: h = intValue
            case .hbp: hbp = intValue
            case .hr: hr = intValue
            case .ibb: ibb = intValue
            case .oneB: oneB = intValue
            case .pa: pa = intValue
            case .r: r = intValue
            case .rbi: rbi = intValue
            case .sb: sb = intValue
            case .sf: sf = intValue
            case .so: so = intValue
            case .tb: tb = intValue
            case .threeB: threeB = intValue
            case .twoB: twoB = intValue
            default: break
        }
    }

    private func saveEditedStats() {
        let newStats = PlayerStatsEntity(context: viewContext)
        newStats.projectionType = "myProjections"

        for statKey in PlayerStatsEntity.StatKeys.useful {
            let newValue = editedStats[statKey] ?? (playerStats.value(forKey: statKey.rawValue) as? Double ?? 0)
            newStats.setValue(newValue, forKey: statKey.rawValue)
        }

        do {
            try viewContext.save()
        } catch {
            print("Error saving edited stats: \(error)")
        }
    }
}
