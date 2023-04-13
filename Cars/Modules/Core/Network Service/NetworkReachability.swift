//
//  NetworkReachability.swift
//  Cars
//
//  Created by Linkon Sid on 21/1/23.
//
import Combine
import Reachability
import CombineReachability

enum NetworkStatus {
    case available
    case offline
    case none
}

protocol ReachabilityProtocol {
    var status: NetworkStatus { get }
    var statusPublisher: Published<NetworkStatus>.Publisher { get }
    func checkReachability()
}

final class NetworkReachability: ReachabilityProtocol {
    @Published private(set) var status: NetworkStatus = .none
    var statusPublisher: Published<NetworkStatus>.Publisher { $status }
    private var reachability: Reachability?
    private var subscriptions = Set<AnyCancellable>()

    deinit {
        reachability?.stopNotifier()
    }

    init() {
        do {
            reachability = try Reachability()
            try? reachability?.startNotifier()
        } catch {
            #if DEBUG
            print("error")
            #endif
        }
    }

    func checkReachability() {
        reachability?.reachabilityChanged
          .sink(receiveValue: { [unowned self] reachability in
              switch reachability.connection {
              case .unavailable:
                  status = .offline
              case .cellular, .wifi:
                  status = .available
              default:
                  status = .none
              }
          })
          .store(in: &subscriptions)
    }
}
