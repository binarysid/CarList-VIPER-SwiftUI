//
//  CarListViewModelTest.swift
//  CarsTests
//
//  Created by Linkon Sid on 22/12/22.
//

import XCTest
import Combine
@testable import Cars

class CarListViewModelTest: XCTestCase {
    var viewModel: CarListViewModel!
    var persistenceContainer = CoreDataStackTest.shared.persistentContainer
    var subscriptions = Set<AnyCancellable>()
    var expectation:XCTestExpectation!
    
    override class func setUp() {
        DIManager.shared.container.register(NetWorkerProtocol.self) { _  in
            return CarAPIWorker(client: MockCarAPIRepository())
        }
        DIManager.shared.container.register(CarPersistenceWorkerProtocol.self) { _  in
            return CarPersistenceWorker(mainContext: .Main(CoreDataStackTest.shared.mainContext), backgroundContext: .Background(CoreDataStackTest.shared.backgroundContext))
        }
        DIManager.shared.container.register(CarDataWorkerProtocol.self){ _ in
            return CarDataWorker()
        }
    }
    override func setUp() {
        viewModel = CarListViewModel()
        expectation = expectation(description: "Car list expectation")

    }
    func test_fetch_data(){
        viewModel.objectWillChange.sink { val in
            print("Articles view model changed!\(val)")
            if type(of: val) == CarViewData.self{
                self.expectation.fulfill()
            }
        }
        .store(in: &subscriptions)
//        viewModel.$viewObject
//            .sink(receiveValue: {[weak self] in viewData
//
//            })
//            .store(in: &subscriptions)
        viewModel.fetchData()
        self.waitForExpectations(timeout: 30.0, handler: nil)
    }
    override func tearDown() {
        viewModel = nil
        expectation = nil
    }

    override class func tearDown() {
        super.tearDown()
        CoreDataStackTest.shared.persistentContainer.destroyPersistentStore()
    }

}
