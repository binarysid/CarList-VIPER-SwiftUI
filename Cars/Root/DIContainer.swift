//
//  Injector.swift
//  Cars
//
//  Created by Linkon Sid on 17/12/22.
//

import Swinject

@propertyWrapper
struct Inject<T>{
    let wrappedValue:T
    init(){
        self.wrappedValue = DIManager.shared.resolve(T.self)
    }
}

// All the dependencies are created/invoked/registered from this manager
final class DIManager {
    static let shared = DIManager()
    var container = Container()
    
    func resolve<T>(_ type: T.Type) -> T {
        container.resolve(T.self)!
    }
    private func registerAPIWorker(){
        container.register(NetWorkerProtocol.self) { _  in
            return CarAPIWorker(client: CarAPIRepository())
        }
    }
    private func registerPersistenceWorker(){
        container.register(CarPersistenceWorkerProtocol.self) { _  in
            // Injecting context is mandatory because we will use different context for unit testing
            return CarPersistenceWorker(mainContext: .Main(CoreDataStack.mainContext), backgroundContext: .Background(CoreDataStack.backgroundContext))
        }
    }
    private func registerNetworkRechability(){
        container.register(ReachabilityProtocol.self){ _ in
            return NetworkReachability()
        }
    }
    func registerAllDependencies(){
        Self.shared.registerAPIWorker()
        Self.shared.registerPersistenceWorker()
        Self.shared.registerNetworkRechability()
    }
    
}
