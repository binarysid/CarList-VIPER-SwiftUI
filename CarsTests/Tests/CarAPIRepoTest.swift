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
}
