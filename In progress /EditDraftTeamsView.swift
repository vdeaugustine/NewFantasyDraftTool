//
//  EditDraftTeamsView.swift
//  NewFantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/27/23.
//

import SwiftUI

// MARK: - EditDraftTeamsView

struct EditDraftTeamsView: View {
    @Environment(\.managedObjectContext) private var viewContext

    let draft: Draft

    @State private var teams: [DraftTeam]

    init(draft: Draft) {
        self.draft = draft
        _teams = State(initialValue: draft.sortedTeamsArray)
    }

    var body: some View {
        Form {
            ForEach(teams) { team in
                Section(header: Text("Team \(team.draftPosition)")) {
                    TextField("Team Name", text: Binding(get: { team.name ?? "" },
                                                         set: { name in
                                                             team.name = name.isEmpty ? nil : name
                                                             save()
                                                         }))
                }
            }
        }
        .navigationTitle("Edit Teams")
        .toolbarSave {
            save()
        }
    }

    private func save() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Error saving draft: \(nsError)")
        }
    }
}

private extension Draft {
    var teamsArray: [DraftTeam] {
        if let teams = teams {
            return Array(teams) as? [DraftTeam] ?? []
        } else {
            return []
        }
    }

    var sortedTeamsArray: [DraftTeam] {
        return teamsArray.sorted(by: { team1, team2 -> Bool in
            if team1.draftPosition == team2.draftPosition {
                return team1.name ?? "" < team2.name ?? ""
            } else {
                return team1.draftPosition < team2.draftPosition
            }
        })
    }
}

// MARK: - EditDraftTeamsView_Previews

struct EditDraftTeamsView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext

        let draft = Draft(context: context)
        draft.name = "Test Draft"
        draft.settings = .generateDefault(context: context)
        //        if var settings = draft.settings {
        //            settings.numberOfTeams = 10
        //            settings.numberOfRounds = 30
        //            draft.settings = settings
        //        }

        if let numberOfTeams = draft.settings?.numberOfTeams {
            for i in 1 ... numberOfTeams {
                let team = DraftTeam(context: context)
                team.draftPosition = Int16(i)
                team.name = "Team \(i)"
                draft.addToTeams(team)
            }
        }

        do {
            try context.save()
        } catch {
            fatalError("Error saving preview draft: \(error)")
        }

        return NavigationView {
            EditDraftTeamsView(draft: draft)
        }
        .environment(\.managedObjectContext, context)
    }
}
