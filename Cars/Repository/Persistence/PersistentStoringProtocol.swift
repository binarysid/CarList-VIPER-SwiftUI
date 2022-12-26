//
//  PersistentStoringProtocol.swift
//  Cars
//
//  Created by Linkon Sid on 19/12/22.
//

import CoreData

// this protocol composed all the required protocol for coredata publishers
typealias PersistentStoringProtocol = RepositoryProtocol & CDEntityCreating & CDSaveModelPublishing
typealias PersistenceFailure = PersistenceService.Error

protocol CDEntityCreating{
    func createEntity<T:NSManagedObject>(context:NSManagedObjectContext)->T
}
extension CDEntityCreating{
    func createEntity<T:NSManagedObject>(context:NSManagedObjectContext)->T{
        return T(context: context)
    }
}
protocol CDSaveModelPublishing {
    associatedtype T:NSManagedObject
    associatedtype CompletionStatusHandler = (Result<T,PersistenceFailure>)-> Void
    func save(_ context:NSManagedObjectContext, _ action: @escaping CoreDataSaveActionHandler<T>) -> CDSaveModelPublisher<T>
}
extension CDSaveModelPublishing {
    func save(_ context:NSManagedObjectContext, _ action: @escaping CoreDataSaveActionHandler<T>) -> CDSaveModelPublisher<T> {
        return CDSaveModelPublisher(action: action, context: context)
    }
}

typealias CoreDataSaveActionHandler<T:NSManagedObject> = (()->T?)

