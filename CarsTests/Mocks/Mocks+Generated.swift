// Generated using Sourcery 2.0.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif


@testable import Cars






















class CarInteractorProtocolMock: CarListInteracting {




    //MARK: - fetchCars

    var fetchCarsThrowableError: Error?
    var fetchCarsCallsCount = 0
    var fetchCarsCalled: Bool {
        return fetchCarsCallsCount > 0
    }
    var fetchCarsReturnValue: [CarData]!
    var fetchCarsClosure: (() async throws -> [CarData])?

    func fetchCars() async throws -> [CarData] {
        if let error = fetchCarsThrowableError {
            throw error
        }
        fetchCarsCallsCount += 1
        if let fetchCarsClosure = fetchCarsClosure {
            return try await fetchCarsClosure()
        } else {
            return fetchCarsReturnValue
        }
    }

}
