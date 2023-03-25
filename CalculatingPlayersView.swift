//
//  CalculatingPlayersView.swift
//  NewFantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/24/23.
//

import SwiftUI
import CoreData
import Vin

// MARK: - CalculatingPlayersView

struct CalculatingPlayersView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var scoringSettings: ScoringSettings
    @State private var isCalculating = false
    @State private var calculatedPoints: [CalculatedPoints] = []
    
    
    
    var body: some View {
        VStack {
            if isCalculating {
                ProgressView("Calculating scores...")
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
                scoringSettings.calculatePointsForAllPlayers {
                    calculatedPoints = $0
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
