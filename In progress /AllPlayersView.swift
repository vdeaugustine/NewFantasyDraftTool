//
//  AllPlayersView.swift
//  NewFantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/25/23.
//

import SwiftUI

import CoreData

// MARK: - AllPlayersView

struct AllPlayersView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var currentProjectionType: ProjectionType
    @State private var selectedStat: PlayerStatsEntity.StatKeys

    @FetchRequest private var playerStats: FetchedResults<PlayerStatsEntity>

    init(currentProjectionType: ProjectionType, firstStat: PlayerStatsEntity.StatKeys) {
        _currentProjectionType = State(initialValue: currentProjectionType)
        let fetchRequest = PlayerStatsEntity.fetchRequestForProjectionType(projectionType: currentProjectionType, sortBy: firstStat)
        _selectedStat = State(initialValue: firstStat)
        _playerStats = FetchRequest(fetchRequest: fetchRequest)
    }

    var body: some View {
        VStack {
            Picker("Projection Type", selection: $currentProjectionType) {
                ForEach(ProjectionType.allCases, id: \.self) { projectionType in
                    Text(projectionType.rawValue).tag(projectionType)
                }
            }
            .padding()

            Picker("Stat Type", selection: $selectedStat) {
                ForEach(PlayerStatsEntity.StatKeys.allCases, id: \.self) { stat in
                    Text(stat.rawValue).tag(stat)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(height: 150)
            .clipped()
            .padding()
            .onChange(of: selectedStat) { _ in
                updateFetchRequest()
            }

            List(playerStats, id: \.objectID) { playerStat in
                let attributeName = playerStat.attributeName(for: selectedStat)
                let value = playerStat.value(forKey: attributeName)
                Text("\(playerStat.playerName ?? ""): \(formattedStatValue(value))")
            }
        }
        .navigationTitle("Filtered Stats")
        .onAppear(perform: {
            updateFetchRequest()
        })
    }

    func updateFetchRequest() {
        let predicate = NSPredicate(format: "projectionType == %@", currentProjectionType.rawValue)
        playerStats.nsPredicate = predicate
    }

    func formattedStatValue(_ value: Any?) -> String {
        if let intValue = value as? Int64 {
            return String(intValue)
        } else if let doubleValue = value as? Double {
            return String(format: "%.2f", doubleValue)
        } else if let stringValue = value as? String {
            return stringValue
        }

        return "N/A"
    }
}

extension PlayerStatsEntity {
    static func fetchRequestForProjectionType(projectionType: ProjectionType, sortBy statKey: StatKeys) -> NSFetchRequest<PlayerStatsEntity> {
            let request: NSFetchRequest<PlayerStatsEntity> = PlayerStatsEntity.fetchRequest()
            request.predicate = NSPredicate(format: "projectionType == %@", projectionType.rawValue)
            request.sortDescriptors = [NSSortDescriptor(key: statKey.rawValue, ascending: false)]
            return request
        }
}

// MARK: - AllPlayersView_Previews

struct AllPlayersView_Previews: PreviewProvider {
    static var previews: some View {
        AllPlayersView(currentProjectionType: .atc, firstStat: .hr)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
