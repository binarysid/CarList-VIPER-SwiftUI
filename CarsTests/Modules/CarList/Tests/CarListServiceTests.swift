//
//  CarListServiceTests.swift
//  CarsTests
//
//  Created by Linkon Sid on 18/4/23.
//

import XCTest
@testable import Cars

final class CarListServiceTests: XCTestCase {
    private var sut: CarListService!
    private var webService: AsyncServiceMock!
    private var expectation: XCTestExpectation!

    override func setUp() {
        webService = AsyncServiceMock()
        webService.data = CarListMockData.createModelRawData()
        webService.url = CarListMockData.url
        webService.response = CarListMockData.response
        webService.throwableError = NetworkError.invalidResponse
        sut = CarListService(webService: webService)
        expectation = expectation(description: "Expectation for \(Self.description())")
        super.setUp()
    }

    func test_fetch_service() async {
        do{
            let data = try await sut.fetchList()
            XCTAssert(data.count>0, "Car List not found")
            expectation.fulfill()
        } catch {
            XCTFail("service request failed")
            expectation.fulfill()
        }
        await self.waitForExpectations(timeout: 0.0, handler: nil)
    }

    override func tearDown() {
        webService = nil
        sut = nil
        expectation = nil
        super.tearDown()
    }
}
