//
//  EditScoringSettingsView.swift
//  NewFantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/24/23.
//

import SwiftUI

// MARK: - CreateNewScoringSettingsView

struct CreateNewScoringSettingsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var selectedStat: String?
    @State private var editedValue: String = ""
    @State private var showAlert: Bool = false

    @StateObject private var scoringSetting: ScoringSettings = .defaultScoring

    @State private var presentError: Bool = false

    @State private var errorVal: String = ""

    @State private var showError: Bool = false

    @State private var name: String = ""

    @State private var noName = false

    @State private var didSave = false
    @State private var goNext = false
    @Environment (\.dismiss) private var dismiss

    var tempName: String {
        "Scoring Settings \(ScoringSettings.count(context: viewContext) + 1)"
    }

    var errorMessage: String {
        "\(errorVal) is not a valid number."
    }

    var alertMessage: String {
        guard let selectedStat = selectedStat else {
            return "Error. Please tap Cancel"
        }
        return "Enter a new value for \(selectedStat)"
    }

    var body: some View {
        List {
            Section("Name") {
                TextField(tempName, text: $name)
            }

            Section("Batter") {
                statRow("TB", scoringSetting.tb)
                statRow("R", scoringSetting.r)
                statRow("RBI", scoringSetting.rbi)
                statRow("SB", scoringSetting.sb)
                statRow("CS", scoringSetting.cs)
                statRow("BB", scoringSetting.bb)
                statRow("Batter K", scoringSetting.batterK)
                statRow("Wins", scoringSetting.wins)
            }
            Section("Pitcher") {
                statRow("Losses", scoringSetting.losses)
                statRow("Saves", scoringSetting.saves)
                statRow("Earned Runs", scoringSetting.er)
                statRow("Pitcher K", scoringSetting.pitcherK)
                statRow("Innings Pitched", scoringSetting.ip)
                statRow("Hits Allowed", scoringSetting.hitsAllowed)
                statRow("Walks Allowed", scoringSetting.walksAllowed)
                statRow("Quality Starts", scoringSetting.qs)
            }
            
            if goNext {
                NavigationLink("GO") {
                    CalculatingPlayersView(scoringSettings: scoringSetting)
                }
            }
        }
        .alert("Successfully saved", isPresented: $didSave, actions: {
            Button("OK") {
                goNext = true
            }
        })
        .toolbarSave {
            guard !ScoringSettings.isDuplicateName(name: name) else {
                noName = true
                return
            }

            do {
                scoringSetting.name = name
                try viewContext.save()
                didSave = true
            } catch {
                print("ERROR SAVING")
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    hideKeyboard()
                }
            }
        }
        .alert("You must enter a unique name for these settings", isPresented: $noName) {}
        .navigationTitle("New Scoring Setting")
        .alert(alertMessage, isPresented: $showAlert) {
            TextField(editedValue, text: $editedValue)
                .keyboardType(.decimalPad)
            Button("Submit") {
                guard let selectedStat = selectedStat,
                      let editedValue = Double(editedValue) else {
                    errorVal = "\(editedValue)"
                    showError = true
                    return
                }
                switch selectedStat {
                    case "TB":
                        scoringSetting.tb = editedValue
                    case "R":
                        scoringSetting.r = editedValue
                    case "RBI":
                        scoringSetting.rbi = editedValue
                    case "SB":
                        scoringSetting.sb = editedValue
                    case "CS":
                        scoringSetting.cs = editedValue
                    case "BB":
                        scoringSetting.bb = editedValue
                    case "Batter K":
                        scoringSetting.batterK = editedValue
                    case "Wins":
                        scoringSetting.wins = editedValue
                    case "Losses":
                        scoringSetting.losses = editedValue
                    case "Saves":
                        scoringSetting.saves = editedValue
                    case "Earned Runs":
                        scoringSetting.er = editedValue
                    case "Pitcher K":
                        scoringSetting.pitcherK = editedValue
                    case "Innings Pitched":
                        scoringSetting.ip = editedValue
                    case "Hits Allowed":
                        scoringSetting.hitsAllowed = editedValue
                    case "Walks Allowed":
                        scoringSetting.walksAllowed = editedValue
                    case "Quality Starts":
                        scoringSetting.qs = editedValue
                    default:
                        break
                }
            }
            Button("Cancel", role: .cancel) {}
        }

        .alert("Error. Could not set new value.", isPresented: $showError) {
            Button("OK") {
                errorVal = ""
                showError = false
                
            }
        } message: {
            Text(errorMessage)
        }
    }

    private func statRow(_ name: String, _ value: Double) -> some View {
        Button {
            selectedStat = name
            editedValue = String(value)
            showAlert = true
        } label: {
            Text(name).spacedOut(text: value.simpleStr())
        }
    }

    private func updateValue(for stat: String, value: Double) {
        switch stat {
            case "TB":
                scoringSetting.tb = value
            case "R":
                scoringSetting.r = value
            case "RBI":
                scoringSetting.rbi = value
            case "SB":
                scoringSetting.sb = value
            case "CS":
                scoringSetting.cs = value
            case "BB":
                scoringSetting.bb = value
            case "Batter K":
                scoringSetting.batterK = value
            case "Wins":
                scoringSetting.wins = value
            case "Losses":
                scoringSetting.losses = value
            case "Saves":
                scoringSetting.saves = value
            case "Earned Runs":
                scoringSetting.er = value
            case "Pitcher K":
                scoringSetting.pitcherK = value
            case "Innings Pitched":
                scoringSetting.ip = value
            case "Hits Allowed":
                scoringSetting.hitsAllowed = value
            case "Walks Allowed":
                scoringSetting.walksAllowed = value
            case "Quality Starts":
                scoringSetting.qs = value
            default:
                break
        }
    }
}

// MARK: - EditScoringSettingsView_Previews

struct EditScoringSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CreateNewScoringSettingsView()
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
