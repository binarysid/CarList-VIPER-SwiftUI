//
//  Extensions.swift
//  Cars
//
//  Created by Linkon Sid on 20/12/22.
//
import UIKit
import SwiftUI

class AppTheme {
    static func navigationBarColors(background: UIColor?,
                                    titleColor: UIColor? = nil, tintColor: UIColor? = nil ) {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = background ?? .clear
        navigationBarAppearance.titleTextAttributes = [.foregroundColor: titleColor ?? .black]
        navigationBarAppearance.largeTitleTextAttributes = [.foregroundColor: titleColor ?? .black]
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        UINavigationBar.appearance().tintColor = tintColor ?? titleColor ?? .black
    }
}

extension UIImageView {
    func loadFrom(URLAddress: String) {
        guard let url = URL(string: URLAddress) else {
            return
        }
        DispatchQueue.main.async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let loadedImage = UIImage(data: imageData) {
                    self?.image = loadedImage
                }
            }
        }
    }
}

extension View {
    @ViewBuilder func hidden(_ shouldHide: Bool) -> some View {
        switch shouldHide {
        case true: self.hidden()
        case false: self
        }
    }
}
