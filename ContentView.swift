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
                  sortDescriptors: [NSSortDescriptor(keyPath: \PlayerEntity.name, ascending: true)],
                  animation: .default)
    private var playersFetched: FetchedResults<PlayerEntity>
    
    private var playersFiltered: [PlayerEntity] {
        if searchText.isEmpty {
                    return Array(playersFetched)
                } else {
                    return playersFetched.filter { $0.name?.lowercased().contains(searchText.lowercased()) ?? false }
                }
    }
    
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            List {
                ForEach(playersFiltered, id: \.self) { player in
                    NavigationLink(destination: PlayerDetailView(player: player)) {
                        VStack(alignment: .leading) {
                            Text(player.name ?? "")
                                .font(.headline)
                            Text(player.teamFull ?? "")
                                .font(.subheadline)
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            .searchable(text: $searchText) {
                Text("Search")
            }
            Text("Select a player")
        }
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
                    Text("Position: \(player.statsArray.first?.minpos ?? "")")
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
