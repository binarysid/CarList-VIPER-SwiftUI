//
//  ViewModel.swift
//  Cars
//
//  Created by Linkon Sid on 20/1/23.
//

import Combine
import Foundation

protocol CarListViewable {
    var viewObject:[CarViewData]{get}
    var viewObjectPublisher: Published<[CarViewData]>.Publisher { get }
    var viewLoader:Bool{get}
    var viewLoaderPublisher: Published<Bool>.Publisher { get }
    var viewError:Bool{get}
    var viewErrorPublisher: Published<Bool>.Publisher { get }
}
protocol CarListStateProtocol{
    func setViewObject(data:[CarViewData] )
    func setActivityIndicator(show:Bool)
    func setErrorStatus(hasError:Bool)
}
class CarListViewState: ObservableObject {
    @Published var viewObject:[CarViewData] = []
    @Published var viewLoader:Bool = false
    @Published var viewError:Bool = false
}

extension CarListViewState:CarListStateProtocol{
    func setViewObject(data: [CarViewData]) {
        viewObject = data
    }
    
    func setActivityIndicator(show: Bool) {
        viewLoader = show
    }
    
    func setErrorStatus(hasError: Bool) {
        viewError = hasError
    }
    
}
