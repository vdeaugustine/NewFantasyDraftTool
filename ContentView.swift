//
//  ContentView.swift
//  NewFantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/23/23.
//


import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        entity: PlayerEntity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \PlayerEntity.name, ascending: true)],
        animation: .default)
    private var players: FetchedResults<PlayerEntity>

    var body: some View {
        NavigationView {
            List {
                ForEach(players) { player in
                    NavigationLink(destination: PlayerDetailView(player: player)) {
                        VStack(alignment: .leading) {
                            Text(player.name ?? "")
                                .font(.headline)
                            Text(player.team ?? "")
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
            Text("Select a player")
        }
    }
}

struct PlayerDetailView: View {
    @ObservedObject var player: PlayerEntity
    
    var body: some View {
        List {
            Section(header: Text("Player Information")) {
                Text("Name: \(player.name ?? "")")
                Text("Team: \(player.team ?? "")")
                Text("Short Name: \(player.shortName ?? "")")
                Text("Position: \(player.position ?? "")")
            }
            Section(header: Text("Player Stats")) {
                ForEach(player.statsArray, id: \.self) { stats in
                    VStack(alignment: .leading) {
                        Text("Projection Type: \(stats.projectionType ?? "")")
                        Text("Games: \(stats.g)")
                        Text("At Bats: \(stats.ab)")
                        // Add other stats as desired
                    }
                    .padding()
                }
            }
        }
        .navigationTitle(player.name ?? "")
        .listStyle(GroupedListStyle())
    }
}

extension PlayerEntity {
    var statsArray: [PlayerStatsEntity] {
        let set = stats as? Set<PlayerStatsEntity> ?? []
        return set.sorted {
            $0.projectionType ?? "" < $1.projectionType ?? ""
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
