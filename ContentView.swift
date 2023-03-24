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
    
    let positions = ["C", "1B", "2B", "3B", "SS", "LF", "CF", "RF", "DH", "P"]
    
    @State private var currentIndex = 0

    var body: some View {
        NavigationView {
            ZStack(alignment: .trailing) {
                List {
                    ForEach(players) { player in
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
                .listStyle(PlainListStyle())
                VStack {
                    ForEach(positions, id: \.self) { position in
                        Button(action: {
                            self.currentIndex = positions.firstIndex(of: position) ?? 0
                        }) {
                            Text(position)
                                .foregroundColor(currentIndex == positions.firstIndex(of: position) ? .accentColor : .primary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 2)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(.top, 6)
                .padding(.trailing, 10)
            }
            .navigationTitle("Players")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                UITableView.appearance().separatorStyle = .none
            }
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
