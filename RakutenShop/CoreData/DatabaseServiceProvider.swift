//
//  DatabaseServiceProvider.swift
//  RakutenShop
//
//  Created by Garnik Ghazaryan on 2/18/20.
//  Copyright © 2020 Garnik Ghazaryan. All rights reserved.
//

import CoreData

class DatabaseServiceProvider: DatabaseServices {
    typealias T = DatabaseTask
    typealias Output = NSManagedObject
    
    let persistentContainerName: String
    
    init(persistentContainerName: String) {
        self.persistentContainerName = persistentContainerName
    }
    
    /*
     let description = NSPersistentStoreDescription()
     description.type = NSInMemoryStoreType // set desired type
     
     if description.type == NSSQLiteStoreType || description.type == NSBinaryStoreType {
     // for persistence on local storage we need to set url
     description.url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
     .first?.appendingPathComponent("database")
     }
     self.persistentContainer.persistentStoreDescriptions = [description]
     */
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: persistentContainerName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var context = persistentContainer.viewContext
    
    func perform(completion: @escaping (NSManagedObjectContext) throws -> Void) {
        context.perform { [weak self] in
            do {
                guard let self = self else { return }
                _ = try completion(self.context)
                self.saveContext()
            } catch {
                print("error")
            }
        }
    }
    
    func fetch<Output>(objectType: Output.Type) -> [Output] {
        let entityName = String(describing: objectType)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        do {
            let result = try context.fetch(fetchRequest) as? [Output]
            return result ?? [Output]()
        } catch {
            return [Output]()
        }
    }
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
