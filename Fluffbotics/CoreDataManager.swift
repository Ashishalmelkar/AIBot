//
//  CoreDataManager.swift
//  Fluffbotics
//
//  Created by Equipp on 28/11/25.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {

    static let shared = CoreDataManager()

    private init() {}

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    private var persistentContainer: NSPersistentContainer {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer
    }

    func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteAllConnectedDevices() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FluffDevices")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            // Execute delete
            try context.execute(deleteRequest)

            // Reset context after batch delete (important!)
            context.reset()

            print("🔥 All FluffDevices deleted successfully.")
        } catch {
            print("❌ Failed to delete devices: \(error.localizedDescription)")
        }
    }

}
