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
    @State private var projectionType: ProjectionType = .steamer
    
    func fetchedResults() -> [CalculatedPoints] {
        let fetchRequest = NSFetchRequest<CalculatedPoints>(entityName: "CalculatedPoints")
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \CalculatedPoints.amount, ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "scoringName == %@ AND projectionType == %@", scoringSettings.name!, projectionType.rawValue)
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
                ProgressView("Calculating and sorting scores...", value: loadingManager.progress)
            } else {
                Picker("Projection", selection: $projectionType) {
                    ForEach(ProjectionType.allCases, id: \.self) { proj in
                        Text(proj.title).tag(proj)
                    }
                }
                .onChange(of: projectionType) { newValue in
                    calculatedPoints = fetchedResults()
                }
                List(calculatedPoints) { calculatedPoint in
                    if let amount = calculatedPoint.amount,
                       let playerName = calculatedPoint.getPlayer()?.name,
                       let projectionType = calculatedPoint.projectionType { // Fetch player's name using the helper function
                        VStack {
                            Text("\(playerName)")
                                .spacedOut(text: "\(amount.simpleStr())")
                            Text(projectionType)
                                .font(.footnote)
                        }
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
                scoringSettings.calculatePointsForAllPlayers(context: viewContext, loadingManager) {
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
