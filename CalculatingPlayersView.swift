//
//  CalculatingPlayersView.swift
//  NewFantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/24/23.
//

import CoreData
import SwiftUI
import Vin

// MARK: - CalculatingPlayersView

struct CalculatingPlayersView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var scoringSettings: ScoringSettings
    @State private var isCalculating = false
    @State private var calculatedPoints: [CalculatedPoints] = []
    @StateObject private var loadingManager = CalculatingLoadingManager.shared

    func fetchedResults() -> [CalculatedPoints] {
        let fetchRequest = NSFetchRequest<CalculatedPoints>(entityName: "CalculatedPoints")
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \CalculatedPoints.amount, ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "scoringName == %@", scoringSettings.name!)
        do {
            let results = try viewContext.fetch(fetchRequest)
            return results
        } catch {
            print("Error fetching results: \(error)")
            return []
        }
    }

    var body: some View {
        VStack {
            if isCalculating {
                ProgressView("Calculating scores...", value: loadingManager.progress)
                Text("Calculating scores")
            } else {
                List(calculatedPoints) { calculatedPoint in
                    if let id = calculatedPoint.playerId,
                       let amount = calculatedPoint.amount {
                        Text("\(id)")
                            .spacedOut(text: "\(amount.simpleStr())")
                    }

                    if calculatedPoints.isEmpty {
                        Text("Empty")
                    }
                }
            }
        }
        .onAppear {
            isCalculating = true

            DispatchQueue.global(qos: .background).async {
                scoringSettings.calculatePointsForAllPlayers(loadingManager) {
                    calculatedPoints = $0
                    calculatedPoints = fetchedResults()
                    DispatchQueue.main.async {
                        isCalculating = false
                    }
                }
            }
        }
    }
}

// MARK: - CalculatingPlayersView_Previews

struct CalculatingPlayersView_Previews: PreviewProvider {
    static var previews: some View {
        CalculatingPlayersView(scoringSettings: .defaultScoring)
    }
}
