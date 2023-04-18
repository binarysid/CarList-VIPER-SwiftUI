//
//  CarListRoutingMock.swift
//  CarsTests
//
//  Created by Linkon Sid on 18/4/23.
//

import Foundation
import SwiftUI
@testable import Cars

class CarListRoutingMock: CarListRouting {
    func makeDetailView(with data: CarViewData) -> CarDetailView {
        CarDetailView(details: data)
    }

    static func createModule() -> some View {
        return EmptyView()
    }
}
