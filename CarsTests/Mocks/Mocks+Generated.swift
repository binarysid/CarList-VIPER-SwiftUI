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






















class CarListFetchingMock: CarListFetching {




    //MARK: - fetchList

    var fetchListThrowableError: Error?
    var fetchListCallsCount = 0
    var fetchListCalled: Bool {
        return fetchListCallsCount > 0
    }
    var fetchListReturnValue: [CarData]!
    var fetchListClosure: (() async throws -> [CarData])?

    func fetchList() async throws -> [CarData] {
        if let error = fetchListThrowableError {
            throw error
        }
        fetchListCallsCount += 1
        if let fetchListClosure = fetchListClosure {
            return try await fetchListClosure()
        } else {
            return fetchListReturnValue
        }
    }

}
class CarListInteractingMock: CarListInteracting {


    var presenter: CarListPresenting?


    //MARK: - fetchCars

    var fetchCarsCallsCount = 0
    var fetchCarsCalled: Bool {
        return fetchCarsCallsCount > 0
    }
    var fetchCarsClosure: (() async -> Void)?

    func fetchCars() async {
        fetchCarsCallsCount += 1
        await fetchCarsClosure?()
    }

}
class CarListPresentingMock: CarListPresenting {


    var router: (any CarListRouting)?
    var interactor: CarListInteracting?
    var view: CarListViewOutput?


    //MARK: - didFetchCars

    var didFetchCarsResultCallsCount = 0
    var didFetchCarsResultCalled: Bool {
        return didFetchCarsResultCallsCount > 0
    }
    var didFetchCarsResultReceivedResult: Result<[CarData], NetworkError>?
    var didFetchCarsResultReceivedInvocations: [Result<[CarData], NetworkError>] = []
    var didFetchCarsResultClosure: ((Result<[CarData], NetworkError>) -> Void)?

    func didFetchCars(result: Result<[CarData], NetworkError>) {
        didFetchCarsResultCallsCount += 1
        didFetchCarsResultReceivedResult = result
        didFetchCarsResultReceivedInvocations.append(result)
        didFetchCarsResultClosure?(result)
    }

}
class CarListViewInputMock: CarListViewInput {




    //MARK: - fetchCarList

    var fetchCarListCallsCount = 0
    var fetchCarListCalled: Bool {
        return fetchCarListCallsCount > 0
    }
    var fetchCarListClosure: (() async -> Void)?

    func fetchCarList() async {
        fetchCarListCallsCount += 1
        await fetchCarListClosure?()
    }

    //MARK: - makeDetailView

    var makeDetailViewWithCallsCount = 0
    var makeDetailViewWithCalled: Bool {
        return makeDetailViewWithCallsCount > 0
    }
    var makeDetailViewWithReceivedData: CarViewData?
    var makeDetailViewWithReceivedInvocations: [CarViewData] = []
    var makeDetailViewWithReturnValue: CarDetailView?
    var makeDetailViewWithClosure: ((CarViewData) -> CarDetailView?)?

    func makeDetailView(with data: CarViewData) -> CarDetailView? {
        makeDetailViewWithCallsCount += 1
        makeDetailViewWithReceivedData = data
        makeDetailViewWithReceivedInvocations.append(data)
        if let makeDetailViewWithClosure = makeDetailViewWithClosure {
            return makeDetailViewWithClosure(data)
        } else {
            return makeDetailViewWithReturnValue
        }
    }

}
class CarListViewOutputMock: CarListViewOutput {


    var presenter: CarListViewInput?


    //MARK: - update

    var updateDataCallsCount = 0
    var updateDataCalled: Bool {
        return updateDataCallsCount > 0
    }
    var updateDataReceivedData: [CarViewData]?
    var updateDataReceivedInvocations: [[CarViewData]] = []
    var updateDataClosure: (([CarViewData]) -> Void)?

    func update(data: [CarViewData]) {
        updateDataCallsCount += 1
        updateDataReceivedData = data
        updateDataReceivedInvocations.append(data)
        updateDataClosure?(data)
    }

    //MARK: - update

    var updateErrorCallsCount = 0
    var updateErrorCalled: Bool {
        return updateErrorCallsCount > 0
    }
    var updateErrorReceivedError: String?
    var updateErrorReceivedInvocations: [String] = []
    var updateErrorClosure: ((String) -> Void)?

    func update(error: String) {
        updateErrorCallsCount += 1
        updateErrorReceivedError = error
        updateErrorReceivedInvocations.append(error)
        updateErrorClosure?(error)
    }

    //MARK: - showLoader

    var showLoaderCallsCount = 0
    var showLoaderCalled: Bool {
        return showLoaderCallsCount > 0
    }
    var showLoaderClosure: (() -> Void)?

    func showLoader() {
        showLoaderCallsCount += 1
        showLoaderClosure?()
    }

    //MARK: - hideLoader

    var hideLoaderCallsCount = 0
    var hideLoaderCalled: Bool {
        return hideLoaderCallsCount > 0
    }
    var hideLoaderClosure: (() -> Void)?

    func hideLoader() {
        hideLoaderCallsCount += 1
        hideLoaderClosure?()
    }

}
