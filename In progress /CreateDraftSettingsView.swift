//
//  CreateDraftSettingsView.swift
//  NewFantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/27/23.
//

import Combine
import CoreData
import SwiftUI

// MARK: - CreateDraftSettingsView

struct CreateDraftSettingsView: View {
    @Environment(\.managedObjectContext) private var viewContext



//    @State private var draft: Draft
    // State variables
    /// The name of the draft being created.
    @State private var draftName: String = ""
    @State private var isSnakeDraft: Bool = true
    @State private var numberOfRounds: Int16 = 25
    @State private var numberOfTeams: Int16 = 10
    @State private var playersPerTeam: Int16 = 25
    @State private var rosterRequirements: RosterRequirements?
    @State private var showNameAlert = false
    @State private var teamNames: [String]
    @State private var draftSettings: DraftSettings?

    // Initializer
    init() {
        self.teamNames = (1 ... 10).map { "Team \($0)" }
    }



    // Body
    var body: some View {
        Form {
            // Draft name text field
            TextField("Draft Name", text: $draftName)
                .onSubmit {
                    let fetchRequest: NSFetchRequest<Draft> = Draft.fetchRequest()
                    fetchRequest.predicate = NSPredicate(format: "name == %@", draftName)
                    do {
                        let results = try viewContext.fetch(fetchRequest)
                        if !results.isEmpty {
                            showNameAlert.toggle()
                        }
                    } catch {
                        print("Error fetching draft with name \(draftName): \(error.localizedDescription)")
                    }
                }

            // Number of teams stepper
            Stepper(value: $numberOfTeams, in: 8 ... 30) {
                Text("Number of Teams: \(numberOfTeams)")
            }
            .onChange(of: numberOfTeams) { newValue in
                if newValue > teamNames.count {
                    teamNames.append("Team \(newValue)")
                } else {
                    teamNames.remove(at: Int(newValue))
                }
            }

            // Players per team stepper
            Stepper(value: $playersPerTeam, in: 5 ... 40) {
                Text("Number of rounds \(playersPerTeam)")
            }

            // Is snake draft toggle
            Toggle("Is Snake Draft", isOn: $isSnakeDraft)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink("Next") {
                    CreateRosterRequirementsView(
                        draftSettings: .init(context: viewContext,
                                             isSnakeDraft: isSnakeDraft,
                                             numberOfRounds: numberOfRounds,
                                             numberOfTeams: numberOfTeams,
                                             playersPerTeam: playersPerTeam,
                                             rosterRequirements: nil,
                                             scoringSystems: nil)
                    )
                }
            }
        }
        .alert(isPresented: $showNameAlert) {
            Alert(title: Text("Draft Name Already Exists"),
                  message: Text("Please select a different name in order to save."),
                  dismissButton: .default(Text("OK")))
        }
    }


}

// MARK: - CreateDraftSettingsView_Previews

struct CreateDraftSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CreateDraftSettingsView()
        }
    }
}

