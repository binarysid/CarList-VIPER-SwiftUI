//
//  ViewModel.swift
//  Cars
//
//  Created by Linkon Sid on 20/1/23.
//

import Combine
import Foundation

protocol CarListViewable {
    // Wrapped value
    var viewObject:[CarViewData]{get}
     // Publisher
    var viewObjectPublisher: Published<[CarViewData]>.Publisher { get }
    var viewLoader:Bool{get}
    var viewLoaderPublisher: Published<Bool>.Publisher { get }
    var viewError:Bool{get}
    var viewErrorPublisher: Published<Bool>.Publisher { get }
}

class CarListViewModel: ObservableObject {

    @Published var viewObject:[CarViewData] = []
    @Published var viewLoader:Bool = false
    @Published var viewError:Bool = false
    var viewDelegate: CarListViewable
    var subscriptions = Set<AnyCancellable>()

    init(viewDelegate: CarListViewable) {
        self.viewDelegate = viewDelegate
        // subscribe to view data stream
        viewDelegate
                .viewObjectPublisher
                .receive(on: RunLoop.main)
                .sink { [weak self] data in
                    self?.viewObject = data
            }
                .store(in: &subscriptions)
        // subscribe to activity indicator stream
        viewDelegate
                .viewLoaderPublisher
                .receive(on: RunLoop.main)
                .sink { [weak self] value in
                    self?.viewLoader = value
            }
                .store(in: &subscriptions)
        // subscribe to error stream
        viewDelegate
                .viewErrorPublisher
                .receive(on: RunLoop.main)
                .sink { [weak self] value in
                    self?.viewError = value
            }
                .store(in: &subscriptions)
    }

}

