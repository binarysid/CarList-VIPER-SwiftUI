//
//  Loadable.swift
//  Cars
//
//  Created by Linkon Sid on 18/4/23.
//

// Protocol for progress view show/hide for long running requests
protocol Loadable {
    func showLoader()
    func hideLoader()
}
