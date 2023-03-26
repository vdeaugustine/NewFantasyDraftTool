//
//  ContentView.swift
//  NewFantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/23/23.
//

import CoreData
import SwiftUI
import Vin

// MARK: - ContentView

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(entity: PlayerEntity.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \PlayerEntity.position, ascending: true),
                                    NSSortDescriptor(keyPath: \PlayerEntity.name, ascending: true)],
                  animation: .default)
    private var players: FetchedResults<PlayerEntity>
    let projectionType = ProjectionType.steamer

    let positions = ["C", "1B", "2B", "3B", "SS", "LF", "CF", "RF", "DH", "P"]

    var sortedPlayers: [PlayerEntity] {
        let filteredPlayers = players.filter { player in
            player.calculatedPoints(for: projectionType, in: viewContext) != nil
        }

        let sortedPlayers = filteredPlayers.sorted { player1, player2 in
            guard let points1 = player1.calculatedPoints(for: projectionType, in: viewContext),
                  let points2 = player2.calculatedPoints(for: projectionType, in: viewContext) else {
                return false
            }
            return points1 > points2
        }
        return sortedPlayers
    }

    @State private var currentIndex = 0

    var body: some View {
        
        NavigationView {
            AllPlayersView(currentProjectionType: .atc, firstStat: .hr)
        }
        
//        NavigationView {
//            List {
//                ForEach(sortedPlayers) { player in
//                    NavigationLink(destination: PlayerDetailView(player: player)) {
//                        HStack {
//                            VStack(alignment: .leading) {
//                                Text(player.name ?? "")
//                                    .font(.headline)
//                                Text(player.teamFull ?? "")
//                                    .font(.subheadline)
//                            }
//
//                            Spacer()
//
//                            if let calculatedPoints = player.calculatedPoints(for: projectionType, in: viewContext) {
//                                Text("\(calculatedPoints, specifier: "%.2f")")
//                                    .font(.subheadline)
//                                    .foregroundColor(.secondary)
//                            }
//                        }
//                    }
//                }
//            }
//
//            .navigationTitle("Players")
//            .navigationBarTitleDisplayMode(.inline)
//        }
    }
}

// MARK: - PlayerDetailView

struct PlayerDetailView: View {
    @ObservedObject var player: PlayerEntity
    @State private var projectionType: ProjectionType = .atc

    var body: some View {
        VStack {
            Picker("Projection Type", selection: $projectionType) {
                ForEach(player.availableProjectionTypes, id: \.self) { projType in
                    Text(projType.rawValue)
                        .tag(projType.rawValue)
                }
            }
            List {
                // Player information section
                Section(header: Text("Player Information")) {
                    Text("Name: \(player.name ?? "")")
                    Text("Team: \(player.teamFull ?? "")")
                    Text("Short Name: \(player.teamShort ?? "")")
                    Text("Position: \(player.position ?? "")")
                }

                Section(header: Text("Player Stats")) {
                    ForEach(StatKeys.Batter.allArr, id: \.self) { statKey in
                        if let statStr = player.getStatStr(for: statKey, projectionType: projectionType) {
                            Text(statKey)
                                .spacedOut(text: statStr)
                        }

                        // Add other stats as desired
                    }
                }
            }
        }
        .navigationTitle([projectionType.rawValue, player.name ?? ""].joined(separator: " "))
        .listStyle(GroupedListStyle())
    }
}

// MARK: - ContentView_Previews

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
