//
//  MockNetworkReachability.swift
//  CarsTests
//
//  Created by Linkon Sid on 21/1/23.
//

import Foundation
@testable import Cars

struct MockNetworkStatus{
    static var status:NetworkStatus = .None
}
final class MockNetworkReachability:ReachabilityProtocol{
    @Published private(set) var status: NetworkStatus = .None
    var statusPublisher: Published<NetworkStatus>.Publisher{ $status }
    
    func checkReachability() {
        self.status = MockNetworkStatus.status
    }
}
