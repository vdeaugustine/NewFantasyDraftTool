//
//  CreateRosterRequirementsView.swift
//  NewFantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/27/23.
//

import CoreData
import SwiftUI

// MARK: - CreateRosterRequirementsView

struct CreateRosterRequirementsView: View {
    @Environment(\.managedObjectContext) private var viewContext

    
    @State private var min1B: Int16 = 1
    @State private var min2B: Int16 = 1
    @State private var min3B: Int16 = 1
    
    @State private var minSS: Int16 = 1
    @State private var minOF: Int16 = 3
    @State private var minRP: Int16 = 5
    @State private var minSP: Int16 = 5
    
    

    let draftSettings: DraftSettings

    private var playersPerTeam: Int16 {
        draftSettings.playersPerTeam
    }

    private var sum: Int16 {
        let sum = min1B + min2B + min3B + minOF + minRP + minSP + minSS
        return sum
    }
    private var isSumGreaterThanPlayersPerTeam: Bool {
        return sum > playersPerTeam
    }
    
    
    private func resetToDefaults() {
        min1B = 1
        min2B = 1
        min3B = 1
        minOF = 3
        minRP = 5
        minSP = 5
        minSS = 1
    }


    var body: some View {
        Form {
            Section("Max players per team") {
                Text(playersPerTeam.str)
            }
            
            Section("Current Num of players") {
                Text("\(sum)")
            }
            Section(header: Text("Minimum positions required")) {
                Stepper(value: min1BBinding, in: 0 ... 10) {
                    Text("Minimum 1B: \(min1B)")
                }

                Stepper(value: min2BBinding, in: 0 ... 10) {
                    Text("Minimum 2B: \(min2B)")
                }

                Stepper(value: min3BBinding, in: 0 ... 10) {
                    Text("Minimum 3B: \(min3B)")
                }

                Stepper(value: minOFBinding, in: 0 ... 10) {
                    Text("Minimum OF: \(minOF)")
                }

                Stepper(value: minRPBinding, in: 0 ... 10) {
                    Text("Minimum RP: \(minRP)")
                }

                Stepper(value: minSPBinding, in: 0 ... 10) {
                    Text("Minimum SP: \(minSP)")
                }

                Stepper(value: minSSBinding, in: 0 ... 10) {
                    Text("Minimum SS: \(minSS)")
                }
            }

            
            Section {
                Button("Reset Default") {
                    resetToDefaults()
                }
            }

            Button(action: createRosterRequirements) {
                Text("Create")
            }
        }
        .navigationTitle("New Roster Requirements")
    }

    private func createRosterRequirements() {
        withAnimation {
            let newRosterRequirements = RosterRequirements(context: viewContext)
            newRosterRequirements.min1B = min1B
            newRosterRequirements.min2B = min2B
            newRosterRequirements.min3B = min3B
            newRosterRequirements.minOF = minOF
            newRosterRequirements.minRP = minRP
            newRosterRequirements.minSP = minSP
            newRosterRequirements.minSS = minSS

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Error saving new RosterRequirements object: \(nsError)")
            }
        }
    }

    private func getPlayersPerTeam(for rosterRequirements: RosterRequirements) -> Int16? {
        guard let draftSettings = rosterRequirements.draftSettings else {
            // If the RosterRequirements object does not have a relationship with a DraftSettings object, return nil
            return nil
        }

        // Access the playersPerTeam variable of the DraftSettings object
        return draftSettings.playersPerTeam
    }
}

extension CreateRosterRequirementsView {
    
    
    // Custom bindings
    
    private var min1BBinding: Binding<Int16> {
        Binding<Int16>(
            get: { self.min1B },
            set: { newValue in
                let newSum = sum - min1B + newValue
                if newSum <= playersPerTeam {
                    min1B = newValue
                } else {
                    print("Cannot set value of min1B to \(newValue) because it would make the sum of the minimums greater than playersPerTeam")
                }
            }
        )
    }
    
    
    private var min2BBinding: Binding<Int16> {
        Binding<Int16>(
            get: { self.min2B },
            set: { newValue in
                let newSum = sum - min2B + newValue
                if newSum <= playersPerTeam {
                    min2B = newValue
                } else {
                    print("Cannot set value of min2B to \(newValue) because it would make the sum of the minimums greater than playersPerTeam")
                }
            }
        )
    }

    private var min3BBinding: Binding<Int16> {
        Binding<Int16>(
            get: { self.min3B },
            set: { newValue in
                let newSum = sum - min3B + newValue
                if newSum <= playersPerTeam {
                    min3B = newValue
                } else {
                    print("Cannot set value of min3B to \(newValue) because it would make the sum of the minimums greater than playersPerTeam")
                }
            }
        )
    }

    private var minOFBinding: Binding<Int16> {
        Binding<Int16>(
            get: { self.minOF },
            set: { newValue in
                let newSum = sum - minOF + newValue
                if newSum <= playersPerTeam {
                    minOF = newValue
                } else {
                    print("Cannot set value of minOF to \(newValue) because it would make the sum of the minimums greater than playersPerTeam")
                }
            }
        )
    }

    private var minRPBinding: Binding<Int16> {
        Binding<Int16>(
            get: { self.minRP },
            set: { newValue in
                let newSum = sum - minRP + newValue
                if newSum <= playersPerTeam {
                    minRP = newValue
                } else {
                    print("Cannot set value of minRP to \(newValue) because it would make the sum of the minimums greater than playersPerTeam")
                }
            }
        )
    }

    private var minSPBinding: Binding<Int16> {
        Binding<Int16>(
            get: { self.minSP },
            set: { newValue in
                let newSum = sum - minSP + newValue
                if newSum <= playersPerTeam {
                    minSP = newValue
                } else {
                    print("Cannot set value of minSP to \(newValue) because it would make the sum of the minimums greater than playersPerTeam")
                }
            }
        )
    }

    private var minSSBinding: Binding<Int16> {
        Binding<Int16>(
            get: { self.minSS },
            set: { newValue in
                let newSum = sum - minSS + newValue
                if newSum <= playersPerTeam {
                    minSS = newValue
                } else {
                    print("Cannot set value of minSS to \(newValue) because it would make the sum of the minimums greater than playersPerTeam")
                }
            }
        )
    }

}

// MARK: - CreateRosterRequirementsView_Previews

struct CreateRosterRequirementsView_Previews: PreviewProvider {
    static var previews: some View {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        let viewContext = PersistenceController.preview.container.viewContext
        let newRosterRequirements = RosterRequirements(context: viewContext)
        return CreateRosterRequirementsView(draftSettings: .generateDefault(context: viewContext))
            .environment(\.managedObjectContext, viewContext)
    }
}
