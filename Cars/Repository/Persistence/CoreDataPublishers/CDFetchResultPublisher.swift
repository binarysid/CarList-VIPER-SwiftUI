//
//  CDFetchResultPublisher.swift
//  Cars
//
//  Created by Linkon Sid on 18/12/22.
//

import Combine
import CoreData

// this publisher provides entity fetching mechanism
struct CDFetchResultPublisher<Entity>:Publisher where Entity: NSManagedObject{
    
    typealias Output = [Entity]
    typealias Failure = PersistenceFailure
    private let request: NSFetchRequest<Entity>
    private let context: NSManagedObjectContext
    
    init(request: NSFetchRequest<Entity>, context: NSManagedObjectContext) {
        self.request = request
        self.context = context
    }
    func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, [Entity] == S.Input {
        let subscription = Subscription(subscriber: subscriber,request: request, context: context)
        subscriber.receive(subscription: subscription)
    }
}

extension CDFetchResultPublisher{
    class Subscription<S> where S:Subscriber, Failure == S.Failure, Output == S.Input{
        private var subscriber: S?
        private let request: NSFetchRequest<Entity>
        private let context: NSManagedObjectContext
        
        init(subscriber: S,request: NSFetchRequest<Entity>, context: NSManagedObjectContext) {
            self.subscriber = subscriber
            self.request = request
            self.context = context
        }
    }
}

extension CDFetchResultPublisher.Subscription:Subscription{
    func request(_ demand: Subscribers.Demand) {
        var demand = demand
        guard let subscriber = subscriber,demand>0 else {
            return
        }
        // perform operation and provides data to the subscribers
        context.performAndWait {[unowned self] in
            do {
                demand -= 1
                let items = try self.context.fetch(self.request)
                if items.count>0{
                    demand += subscriber.receive(items)
                }
                else{
                    subscriber.receive(completion: .failure(.NoDataFound))
                }
            } catch {
                subscriber.receive(completion: .failure(.ServiceNotAvailable))
            }
        }
    }
}
extension CDFetchResultPublisher.Subscription: Cancellable {
    func cancel() {
        subscriber = nil
    }
}
