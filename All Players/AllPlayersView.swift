//
//  AllPlayersView.swift
//  NewFantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/25/23.
//

import SwiftUI

import CoreData

// MARK: - AllPlayersView

// A SwiftUI view that displays a list of player stats based on the selected projection type and stat type.
struct AllPlayersView: View {
    // Get the managed object context from the environment.
    @Environment(\.managedObjectContext) private var viewContext

    // State variables for the current projection type and selected stat.
    @State private var currentProjectionType: ProjectionType
    @State private var selectedStat: PlayerStatsEntity.StatKeys

    // A fetch request for player stats based on the current projection type and selected stat.
    @FetchRequest private var playerStats: FetchedResults<PlayerStatsEntity>

    // Initialize the view with the given projection type and stat type.
    init(currentProjectionType: ProjectionType, firstStat: PlayerStatsEntity.StatKeys) {
        // Set the initial values for the state variables.
        _currentProjectionType = State(initialValue: currentProjectionType)
        _selectedStat = State(initialValue: firstStat)

        // Create a fetch request for the given projection type and stat type.
        let fetchRequest = PlayerStatsEntity.fetchRequestForProjectionType(projectionType: currentProjectionType, sortBy: firstStat)
        // Initialize the fetch request with the created fetch request.
        _playerStats = FetchRequest(fetchRequest: fetchRequest)
    }

    // The body of the view.
    var body: some View {
        VStack {
            HStack {
                // A picker for the projection type.
                Picker("Projection Type", selection: $currentProjectionType) {
                    ForEach(ProjectionType.allCases, id: \.self) { projectionType in
                        Text(projectionType.rawValue).tag(projectionType)
                    }
                }
                .padding()

                // A picker for the selected stat type.
                Picker("Stat Type", selection: $selectedStat) {
                    ForEach(PlayerStatsEntity.StatKeys.allCases, id: \.self) { stat in
                        Text(stat.rawValue).tag(stat)
                    }
                }
                .onChange(of: selectedStat) { _ in
                    // When the selected stat type changes, update the fetch request with the new stat type.
                    updateFetchRequest()
                }
            }

            // A list of player stats based on the current projection type and selected stat type.
            List(playerStats, id: \.objectID) { playerStat in
                let attributeName = playerStat.attributeName(for: selectedStat)
                let value = playerStat.value(forKey: attributeName)
                NavigationLink {
                    PlayerStatsDetailView(playerStats: playerStat)
                } label: {
                    Text("\(playerStat.playerName ?? "")")
                        .spacedOut(text: "\(formattedStatValue(value))")
                        .allPartsTappable(alignment: .leading)
                }
            }
        }
        // Set the navigation title.
        .navigationTitle("Filtered Stats")
        // When the view appears, update the fetch request with the selected stat type.
        .onAppear(perform: {
            updateFetchRequest()
        })
    }

    // Update the fetch request with the current projection type and selected stat type.
    func updateFetchRequest() {
        let predicate = NSPredicate(format: "projectionType == %@", currentProjectionType.rawValue)
        playerStats.nsPredicate = predicate
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
}

// MARK: - AllPlayersView_Previews

struct AllPlayersView_Previews: PreviewProvider {
    static var previews: some View {
        AllPlayersView(currentProjectionType: .atc, firstStat: .hr)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
