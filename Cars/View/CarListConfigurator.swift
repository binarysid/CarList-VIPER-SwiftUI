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

final class CarListConfigurator:ViewConfigurator{
    typealias T = CarListView
    func configure()-> CarListView {
        AppTheme.navigationBarColors(background: .black, titleColor: .white)
        let interactor = CarListInteractor()
        let presenter = CarListPresenter()
        let viewModel = CarListViewModel(viewDelegate: presenter)
        interactor.presenter = presenter
        return CarListView(viewModel: viewModel, interactor: interactor)
    }
    
}
