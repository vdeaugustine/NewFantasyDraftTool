//
//  CreateDraftSettingsView.swift
//  NewFantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/27/23.
//

import SwiftUI

struct CreateDraftSettingsView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var draftName: String = ""
    @State private var numberOfTeams: Int16 = 10
    @State private var playersPerTeam: Int16 = 25
    @State private var numberOfRounds: Int16 = 25
    @State private var isSnakeDraft: Bool = true
    @State private var rosterRequirements: RosterRequirements?

    var body: some View {
        Form {
            Section(header: Text("Draft Settings")) {
                TextField("Draft Name", text: $draftName)
                
                Stepper(value: $numberOfTeams, in: 2...30) {
                    Text("Number of Teams: \(numberOfTeams)")
                }
                
                Stepper(value: $playersPerTeam, in: 1...50) {
                    Text("Players per Team: \(playersPerTeam)")
                }
                
                Stepper(value: $numberOfRounds, in: 1...50) {
                    Text("Number of Rounds: \(numberOfRounds)")
                }
                
                Toggle("Is Snake Draft?", isOn: $isSnakeDraft)
            }
            
            Section(header: Text("Roster Requirements")) {
                NavigationLink(destination: CreateRosterRequirementsView(draftSettings: createDraftSettings())) {
                    Text("Create Roster Requirements")
                }
                
                if let rosterRequirements = rosterRequirements {
                    VStack(alignment: .leading) {
                        Text("Minimum Positions Required:")
                            .font(.headline)
                        
                        Text("1B: \(rosterRequirements.min1B)")
                        Text("2B: \(rosterRequirements.min2B)")
                        Text("3B: \(rosterRequirements.min3B)")
                        Text("OF: \(rosterRequirements.minOF)")
                        Text("RP: \(rosterRequirements.minRP)")
                        Text("SP: \(rosterRequirements.minSP)")
                        Text("SS: \(rosterRequirements.minSS)")
                    }
                }
            }

            Button(action: createDraft) {
                Text("Create Draft")
            }
        }
        .navigationTitle("New Draft")
        .onAppear {
            rosterRequirements = .generateDefault(context: viewContext, draftSettings: .generateDefault(context: viewContext))
        }
    }

    private func createDraftSettings() -> DraftSettings {
        let draftSettings = DraftSettings(context: viewContext)
        draftSettings.playersPerTeam = playersPerTeam
        draftSettings.numberOfTeams = numberOfTeams
        draftSettings.numberOfRounds = numberOfRounds
        draftSettings.isSnakeDraft = isSnakeDraft
        return draftSettings
    }
    
    private func createDraft() {
        withAnimation {
            let draft = Draft(context: viewContext)
            draft.name = draftName
            draft.currentPick = 1
            draft.creationDate = Date()
            
            let draftSettings = createDraftSettings()
            draft.settings = draftSettings
            
            if let rosterRequirements = rosterRequirements {
                draftSettings.rosterRequirements = rosterRequirements
            }
            
            for i in 1...numberOfTeams {
                let draftTeam = DraftTeam(context: viewContext)
                draftTeam.draftPosition = Int16(i)
                draftTeam.name = "Team \(i)"
                draft.addToTeams(draftTeam)
            }

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Error saving new Draft object: \(nsError)")
            }
        }
    }
}

struct CreateDraftSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        CreateDraftSettingsView()
    }
}
