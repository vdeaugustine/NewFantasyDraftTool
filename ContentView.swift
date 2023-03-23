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
            Text("Select a player")
        }
    }
}

struct PlayerDetailView: View {
    @ObservedObject var player: PlayerEntity
    @State private var projectionType: ProjectionType = .atc
    
    
    var body: some View {
        VStack {
            Picker("Projection Type", selection: $projectionType) {
                ForEach(ProjectionType.allCases, id: \.self) { projType in
                    Text(projType.rawValue)
                        .tag(projType.rawValue)
                }
            }
            List {
                Section(header: Text("Player Information")) {
                    Text("Name: \(player.name ?? "")")
                    Text("Team: \(player.teamFull ?? "")")
                    Text("Short Name: \(player.teamShort ?? "")")
                    Text("Position: \(player.statsArray.first?.minpos ?? "")")
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
        }
        .navigationTitle([projectionType.rawValue, player.name ?? ""].joined(separator: " "))
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
    
    func stats(for projectionType: ProjectionType) -> PlayerStatsEntity? {
        self.statsArray.first(where: { $0.projectionType == projectionType.rawValue })
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
