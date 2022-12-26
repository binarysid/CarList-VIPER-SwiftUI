//
//  PersistenceRepository.swift
//  Cars
//
//  Created by Linkon Sid on 18/12/22.
//


import CoreData
import Combine

final class CarLocalRepository:PersistentStoringProtocol{
    
    typealias Context = NSManagedObjectContext
    typealias T = Car
    typealias Request = NSFetchRequest<Car>
    typealias Output = CDFetchResultPublisher<Car>
    private var subscriptions = Set<AnyCancellable>()
    
    func getData(_ request: Request, _ context: Context) -> CDFetchResultPublisher<Car> {
        return CDFetchResultPublisher(request: request, context: context)
    }
    func create(_ item:CarData,context:NSManagedObjectContext, completionHandler: @escaping CompletionStatusHandler){
        let action: CoreDataSaveActionHandler<T> = {[weak self] in
            guard let self = self,let date =  item.dateTime.toDate() else{
                completionHandler(.failure(.DataHandlingError))
                return nil
            }
            let car:Car = self.createEntity(context: context)
            car.id = item.id
            car.title = item.title
            car.ingress = item.ingress
            car.date = date
            car.tags = item.tags.joined(separator: ",")
            car.image = item.image
            return car
        }
        // execute save operation asynchronously
        context.perform {[unowned self] in
            self.save(context, action)
                .sink(receiveCompletion: {completion in
                    if case .failure(let error) = completion,error == .FailedToSave{
                        completionHandler(.failure(.FailedToSave))
                    }
                }, receiveValue: { val in
                    completionHandler(.success(val))
                })
                .store(in: &subscriptions)
        }
    }
    func fetchEntityBy(_ id:Int64,request: Request, context:Context)->Car?{
        var car:Car?
        request.predicate = NSPredicate(format: "id == %d", id)
        // execute fetch operation synchronously
        context.performAndWait {
            let results = try? context.fetch(request)
            car = results?.first
        }
        return car
    }
    func updateEntity(from remoteObject:CarData,to localObject: Car,context:NSManagedObjectContext, completionHandler: @escaping CompletionStatusHandler){
        let action: CoreDataSaveActionHandler<T> = {
            localObject.id = remoteObject.id
            localObject.title = remoteObject.title
            localObject.ingress = remoteObject.ingress
            localObject.date = remoteObject.dateTime.toDate()
            localObject.tags = remoteObject.tags.joined(separator: ",")
            localObject.image = remoteObject.image
            return localObject
        }
        context.perform {[unowned self] in
            self.save(context,action)
                .subscribe(on: DispatchQueue.global(qos: .utility))
                .receive(on: DispatchQueue.global(qos: .utility))
                .sink(receiveCompletion: {completion in
                    if case .failure(let error) = completion,error == .FailedToSave{
                        completionHandler(.failure(.FailedToSave))
                    }
                }, receiveValue: { val in
                    completionHandler(.success(val))
                })
                
                .store(in: &subscriptions)
        }
    }
    func batchDelete(context:NSManagedObjectContext)->AnyPublisher<Bool,PersistenceFailure>{
        var result: AnyPublisher<Bool, PersistenceFailure>!
        let fetchRequest: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Car")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do{
            try context.executeAndMergeChanges(using: batchDeleteRequest)
            result = Result.success(true).publisher.eraseToAnyPublisher()
        }
        catch let error{
            print(error.localizedDescription)
            result = Result.failure(.FailedToDelete).publisher.eraseToAnyPublisher()
        }
        return result
    }
}
