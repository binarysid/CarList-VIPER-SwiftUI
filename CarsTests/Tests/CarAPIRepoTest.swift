//
//  CarAPIRepoTest.swift
//  CarsTests
//
//  Created by Linkon Sid on 20/12/22.
//

import Combine
import XCTest
@testable import Cars

class CarAPIRepoTest: XCTestCase {
    var apiClient: MockCarAPIRepository!
    var apiWorker:CarAPIWorker<MockCarAPIRepository>!
    var expectation:XCTestExpectation!
    var subscriptions = Set<AnyCancellable>()
    let testBundle = Bundle(for: CarsTests.self)
    var dataWorker = CarDataWorker()

    override func setUp() {
        apiClient = MockCarAPIRepository()
        apiWorker = CarAPIWorker(client: apiClient)
        expectation = expectation(description: "Car list expectation")
    }

    override func tearDown() {
        apiClient = nil
        apiWorker = nil
        expectation = nil
        
    }
    func test_apiworker_fetch_car_list(){
        apiWorker.resultPublisher.sink(receiveCompletion: { completion in
            if case .failure(let error) = completion{
                XCTFail(error.errorDescription)
                self.expectation.fulfill()
            }
        }, receiveValue: { data in
            XCTAssertTrue(data.count>0, "No Data Found")
            self.expectation.fulfill()
        })
        .store(in: &subscriptions)
        apiWorker.requestForDomainData()
        self.waitForExpectations(timeout: 0.0, handler: nil)
    }
    func test_data_worker(){
        apiWorker.resultPublisher.sink(receiveCompletion: { completion in
            if case .failure(let error) = completion{
                XCTFail(error.errorDescription)
                self.expectation.fulfill()
            }
        }, receiveValue: {[unowned self] data in
            XCTAssertTrue(data.count>0, "No Data Found")
            let viewData = self.dataWorker.processViewDataFrom(articles: data)
            guard let item = viewData.first else {
                XCTFail("View Data not Found")
                return
            }
            XCTAssertFalse(item.title.isEmpty, "No title Found")
            XCTAssertNotNil(item.image, "No Image found")
            XCTAssertFalse(item.description.isEmpty, "No description Found")
            XCTAssertNotNil(item.date, "No Date found")
            self.expectation.fulfill()
        })
        .store(in: &subscriptions)
        apiWorker.requestForDomainData()
        self.waitForExpectations(timeout: 0.0, handler: nil)
    }
}
