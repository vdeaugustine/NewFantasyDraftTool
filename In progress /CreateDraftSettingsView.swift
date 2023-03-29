//
//  CreateDraftSettingsView.swift
//  NewFantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/27/23.
//

import Combine
import SwiftUI

// MARK: - CreateDraftSettingsView

struct CreateDraftSettingsView: View {
    @Environment(\.managedObjectContext) private var viewContext

//    private var draftNameBinding: Binding<String> {
//        Binding<String>  {
//            draft.name ?? ""
//        } set: { draft.name = $0 }
//    }
//    private var numberOfTeamsBinding: Binding<Int16> {
//        Binding<Int16>(
//            get: { draft.settings?.numberOfTeams ?? 0 },
//            set: { newValue in
//                draft.settings?.numberOfTeams = newValue
//            }
//        )
//    }
//
//    private var numberOfRoundsBinding: Binding<Int16> {
//        Binding<Int16>(
//            get: { draft.settings?.numberOfRounds ?? 0 },
//            set: { newValue in
//                draft.settings?.numberOfRounds = newValue
//            }
//        )
//    }
//
//
//    private var playersPerTeamBinding: Binding<Int16> {
//        Binding<Int16>(
//            get: { draft.settings?.playersPerTeam ?? 0 },
//            set: { newValue in
//                draft.settings?.playersPerTeam = newValue
//            }
//        )
//    }
//
//    private var isSnakeDraftBinding: Binding<Bool> {
//        Binding<Bool>(
//            get: { draft.settings?.isSnakeDraft ?? true },
//            set: { newValue in
//                draft.settings?.isSnakeDraft = newValue
//            }
//        )
//    }
//
//    private var rosterRequirementsBinding: Binding<RosterRequirements?> {
//        Binding<RosterRequirements?>(
//            get: { draft.settings?.rosterRequirements ?? .generateDefault(context: viewContext, draftSettings: draft.settings ?? .generateDefault(context: viewContext)) },
//            set: { newValue in
//                draft.settings?.rosterRequirements = newValue
//            }
//        )
//    }

//    @State private var draft: Draft
    @State private var teamNames: [String]
    @State private var draftName: String = ""
    @State private var numberOfTeams: Int16 = 10
    @State private var playersPerTeam: Int16 = 25
    @State private var numberOfRounds: Int16 = 25
    @State private var isSnakeDraft: Bool = true
    @State private var rosterRequirements: RosterRequirements?
    @State private var draftSettings: DraftSettings?

    init() {
        self.teamNames = (1 ... 10).map { "Team \($0)" }
    }

//    init() {
//        let context = PersistenceController.preview.container.viewContext
//        let draftSettings = DraftSettings.generateDefault(context: context)
//        let rosterRequirements = RosterRequirements.generateDefault(context: context, draftSettings: draftSettings)
//        let draft = Draft.defaultDraft(in: context)
//        draftSettings.rosterRequirements = rosterRequirements
//        _draft = State(initialValue: draft)
//    }

    var body: some View {
        Form {
            TextField("Draft Name", text: $draftName)
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
            Stepper(value: $playersPerTeam, in: 5 ... 40) {
                Text("Number of rounds \(playersPerTeam)")
            }
            Toggle("Is Snake Draft", isOn: $isSnakeDraft)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink("Next") {
                    
                }
                
            }
        }
    }

//    var body: some View {
//        Form {
//            Section(header: Text("Draft Settings")) {
//                TextField("Draft Name", text: $draftName)
//                    .onChange(of: draftName) { newValue in
//                        draft.name = newValue
//                    }
//
//                Stepper(value: $numberOfTeams, in: 2...30) {
//                    Text("Number of Teams: \(draft.settings?.numberOfTeams ?? 999)")
//
//                }
//                .onChange(of: numberOfTeams) { newValue in
//                    draft.settings?.numberOfTeams = newValue
//                }
//
//                ForEach(draft.sortedTeamsArray) { team in
//                    Text(team.name ?? "NA")
//                }
//
//
//                NavigationLink("Edit team names") {
//                    EditDraftTeamsView(draft: draft)
//                }
//
//                Stepper(value: $playersPerTeam, in: 1...50) {
//                    Text("Players per Team: \(draft.settings?.playersPerTeam ?? 0)")
//                }
//                .onChange(of: playersPerTeam) { newValue in
//                    draft.settings?.playersPerTeam = newValue
//                }
//
//                Stepper(value: $numberOfRounds, in: 1...50) {
//                    Text("Number of Rounds: \(numberOfRounds)")
//                }
//                .onChange(of: numberOfRounds) { newValue in
//                    draft.settings?.numberOfRounds = newValue
//                }
//
//                Toggle("Is Snake Draft?", isOn: $isSnakeDraft)
//                    .onChange(of: isSnakeDraft) { newValue in
//                        draft.settings?.isSnakeDraft = newValue
//                    }
//            }
//
//            Section(header: Text("Roster Requirements")) {
//                NavigationLink(destination: CreateRosterRequirementsView(draftSettings: draft.settings ?? .generateDefault(context: viewContext))) {
//                    Text("Create Roster Requirements")
//                }
//
//                if let rosterRequirements = rosterRequirements {
//                    VStack(alignment: .leading) {
//                        Text("Minimum Positions Required:")
//                            .font(.headline)
//
//                        Text("1B: \(rosterRequirements.min1B)")
//                        Text("2B: \(rosterRequirements.min2B)")
//                        Text("3B: \(rosterRequirements.min3B)")
//                        Text("OF: \(rosterRequirements.minOF)")
//                        Text("RP: \(rosterRequirements.minRP)")
//                        Text("SP: \(rosterRequirements.minSP)")
//                        Text("SS: \(rosterRequirements.minSS)")
//                    }
//                }
//            }
//
//            Button("Save") {
//                try? viewContext.save()
//                viewContext.delete
//            }
//        }
//        .navigationTitle("New Draft")
//        .onAppear {
//            rosterRequirements = draft.settings?.rosterRequirements
//        }
//    }

//    private func createDraftSettings() -> DraftSettings {
//        let draftSettings = draft.settings ?? DraftSettings(context: viewContext)
//        draftSettings.playersPerTeam = playersPerTeam
//        draftSettings.numberOfTeams = numberOfTeams
//        draftSettings.numberOfRounds = numberOfRounds
//        draftSettings.isSnakeDraft = isSnakeDraft
//        return draftSettings
//    }

//    private func createDraft() {
//        withAnimation {
//            draft.name = draftName
//            draft.currentPick = 1
//            draft.creationDate = Date()
//
//            let draftSettings = createDraftSettings()
//            draft.settings = draftSettings
//
//            if let rosterRequirements = rosterRequirements {
//                draftSettings.rosterRequirements = rosterRequirements
//            }
//
//            for i in 1...numberOfTeams {
//                let draftTeam = DraftTeam(context: viewContext)
//                draftTeam.draftPosition = Int16(i)
//                draftTeam.name = "Team \(i)"
//                draft.addToTeams(draftTeam)
//            }
//
//            do {
//                try viewContext.save()
//            } catch {
//                let nsError = error as NSError
//                fatalError("Error saving new Draft object: \(nsError)")
//            }
//        }
//    }
}

// MARK: - CreateDraftSettingsView_Previews

struct CreateDraftSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CreateDraftSettingsView()
        }
    }
}
