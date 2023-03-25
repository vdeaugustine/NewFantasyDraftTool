//
//  CalculatingLoadingManager.swift
//  NewFantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/25/23.
//

import Foundation
import Combine

/// CalculatingLoadingManager is a class that manages the progress updates of a long-running task that involves calculating scores for a large number of players. It uses the ObservableObject protocol and the @Published property wrapper to make its progress property observable, which allows SwiftUI to update the UI whenever the progress changes.
///
/// The class follows the singleton pattern, which means that there is only one instance of the class throughout the application. The shared static property is used to get this instance.
///
/// The class has a private cancellables property, which is a set of AnyCancellable instances that manage the lifetimes of Combine framework's publishers. The class also has a private progressSubject property, which is a PassthroughSubject instance that can be used to send progress values.
///
/// The updateProgress function is used to update the progress property. It takes a Double value as a parameter, which represents the progress value. When called, the function sends the value using the progressSubject. The PassthroughSubject forwards the value to the progress property, which is updated.
class CalculatingLoadingManager: ObservableObject {
    // Create a shared instance of the class (singleton pattern) to be used throughout the application
    static let shared = CalculatingLoadingManager()

    // A set to store the Combine framework's cancellable instances to manage their lifetimes
    private var cancellables = Set<AnyCancellable>()

    // Define a @Published property called progress of type Double, which is initialized to 0.0
    // When this property is updated, SwiftUI will automatically update the UI
    @Published var progress: Double = 0.0

    // Create a PassthroughSubject instance of type Double and Never, which can be used to send progress values
    private let progressSubject = PassthroughSubject<Double, Never>()

    // The private initializer for the class
    private init() {
        // Connect the progressSubject to the progress property using the Combine framework
        progressSubject
            // Ensure that the updates are received on the main queue (thread)
            .receive(on: DispatchQueue.main)
            // Assign the received values to the progress property
            .assign(to: &$progress)
    }

    // Define a function called updateProgress that takes a Double value as a parameter
    func updateProgress(_ value: Double) {
        // Send the value using the progressSubject, which will update the progress property and the UI
        
        progressSubject.send(value > 1 ? 1 : value)
    }
}
