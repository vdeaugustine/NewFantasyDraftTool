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

/// A SwiftUI view that displays a list of calculated points for players based on the selected ScoringSettings object
struct CalculatingPlayersView: View {
    // Properties
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var scoringSettings: ScoringSettings
    @State private var isCalculating = false
    @State private var calculatedPoints: [CalculatedPoints] = []
    @StateObject private var loadingManager = CalculatingLoadingManager.shared
    @State private var projectionType: ProjectionType = .steamer
    
    // A function to fetch the results from Core Data
    func fetchedResults() -> [CalculatedPoints] {
        // Create a new NSFetchRequest object for the CalculatedPoints entity
        let fetchRequest = NSFetchRequest<CalculatedPoints>(entityName: "CalculatedPoints")
        
        // Set the sort descriptors and predicate for the fetch request
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \CalculatedPoints.amount, ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "scoringName == %@ AND projectionType == %@", scoringSettings.name!, projectionType.rawValue)
        
        do {
            // Execute the fetch request and return the results
            let results = try viewContext.fetch(fetchRequest)
            return results
            
        } catch {
            // If there was an error, print it and return an empty array
            print("Error fetching results: \(error)")
            return []
        }
    }
    
    // Body
    var body: some View {
        VStack {
            if isCalculating {
                // If the view is still calculating the scores, show a progress view
                ProgressView("Iteration \(loadingManager.iteration)", value: loadingManager.progress)
                
            } else {
                // Otherwise, show a picker to select the projection type and a list of calculated points
                
                // Picker for projection type
                Picker("Projection", selection: $projectionType) {
                    ForEach(ProjectionType.allCases, id: \.self) { proj in
                        Text(proj.title).tag(proj)
                    }
                }
                .onChange(of: projectionType) { _ in
                    calculatedPoints = fetchedResults()
                }
                
                // List of calculated points
                List(calculatedPoints) { calculatedPoint in
                    if let amount = calculatedPoint.amount,
                       let playerName = calculatedPoint.getPlayer()?.name,
                       let projectionType = calculatedPoint.projectionType {
                        // If the necessary properties are not nil, display the player name, calculated points, and projection type in a VStack
                        VStack {
                            Text("\(playerName)")
                                .spacedOut(text: "\(amount.simpleStr())")
                            Text(projectionType)
                                .font(.footnote)
                        }
                    }
                    
                    if calculatedPoints.isEmpty {
                        // If there are no calculated points to display, show an empty text view
                        Text("Empty")
                    }
                }
            }
        }
        .onAppear {
            // When the view appears, set isCalculating to true and start calculating the scores in the background
            
            isCalculating = true
            
            DispatchQueue.global(qos: .background).async {
                scoringSettings.calculatePointsForAllPlayers(context: viewContext, loadingManager) {
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
