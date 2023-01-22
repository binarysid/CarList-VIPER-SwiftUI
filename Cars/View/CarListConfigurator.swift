//
//  CarListViewConfigurator.swift
//  Cars
//
//  Created by Linkon Sid on 20/1/23.
//

import SwiftUI

protocol ViewConfigurator{
    associatedtype T:View
    func configure()->T
}

// VIP Cycle configurator. This class mainly creates relationship between classes
final class CarListConfigurator:ViewConfigurator{
    typealias T = CarListView
    func configure()-> CarListView {
        AppTheme.navigationBarColors(background: .black, titleColor: .white)
        let interactor = CarListInteractor()
        let presenter = CarListPresenter()
        let viewState = CarListViewState()
        presenter.viewState = viewState
        interactor.presenter = presenter
        return CarListView(state: viewState, interactor: interactor)
    }
    
}
