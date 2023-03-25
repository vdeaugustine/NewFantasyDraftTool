//
//  Persistence.swift
//  NewFantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/23/23.
//

import CoreData

/// A controller class that manages a persistent store for the app. It provides an NSPersistentContainer that represents the app's data model and provides access to the container's managed object context.

struct PersistenceController {
    /// A shared instance of PersistenceController to provide easy access to the data model.
    static let shared = PersistenceController()
    
    /// A preview instance of PersistenceController used for in-memory storage, used during development to provide a preview of the app.
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: false)
        let context = result.container.viewContext
        
        // Load sample batters projections and create default scoring settings
        for position in Position.batters {
            for projection in ProjectionType.batterArr {
                loadBatters(projectionType: projection, position: position, container: result.container)
            }
        }
        ScoringSettings.createDefaultScoringSettings(context: context)
        
        return result
    }()
    
    /// An NSPersistentContainer that represents the app's data model and provides access to the container's managed object context.
    let container: NSPersistentContainer
    
    /// Initializes a new PersistenceController instance.
    /// - Parameter inMemory: A Boolean that indicates whether to use in-memory storage.
    init(inMemory: Bool = false) {
        self.container = NSPersistentContainer(name: "NewFantasyDraftTool")
        
        if inMemory {
            // If in-memory storage is requested, set the URL to /dev/null
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        // Load persistent stores and handle errors
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        // Automatically merge changes from the container's parent
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
