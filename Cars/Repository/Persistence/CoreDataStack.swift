//
//  PersistanceService.swift
//  Cars
//
//  Created by Linkon Sid on 18/12/22.
//

import CoreData

final class CoreDataStack{
    private init(){}
    static var mainContext:NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    static var backgroundContext:NSManagedObjectContext{
        get{
            let context = persistentContainer.newBackgroundContext()
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            return context
        }
    }
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel_v1")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
            else{
                let description = NSPersistentStoreDescription()
                description.shouldInferMappingModelAutomatically = true
                description.type = NSSQLiteStoreType
                container.persistentStoreDescriptions = [description]
            }
        })
        return container
    }()
}

extension NSManagedObjectContext {
    public func executeAndMergeChanges(using batchDeleteRequest: NSBatchDeleteRequest) throws {
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        do{
            let result = try execute(batchDeleteRequest) as? NSBatchDeleteResult
            let changes: [AnyHashable: Any] = [NSDeletedObjectsKey: result?.result as? [NSManagedObjectID] ?? []]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [self])
        }catch{
            throw PersistenceFailure.FailedToDelete
        }
    }
}
