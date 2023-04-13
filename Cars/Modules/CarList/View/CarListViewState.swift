//
//  CarViewState.swift
//  Cars
//
//  Created by Linkon Sid on 13/4/23.
//

import Foundation

struct CarListViewState {
    var viewObject: [CarViewData] = []
    var viewLoader: Bool = false
    var viewError: Bool = false
    var errorMessage = ""
}
