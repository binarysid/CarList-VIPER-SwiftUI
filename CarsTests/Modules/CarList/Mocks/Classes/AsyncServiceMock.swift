//
//  AsyncServiceMock.swift
//  CarsTests
//
//  Created by Linkon Sid on 18/4/23.
//

import Foundation
import WebService

@testable import Cars

struct AsyncServiceMock: WebService {
    var data: Data!
    var response: URLResponse!
    var throwableError: Error!
    var url: URL!

    func fetch(_ request: URLRequest) async throws -> (Data, URLResponse) {
        guard !data.isEmpty else { throw throwableError }
        return (data, response)
    }
}
