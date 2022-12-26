//
//  ProgressLoader.swift
//  Cars
//
//  Created by Linkon Sid on 21/12/22.
//

import SwiftUI

struct ProgressLoader: View {
    var tintColor: Color = .blue
    var scaleSize: CGFloat = 1.0
    
    var body: some View {
        ProgressView()
            .scaleEffect(scaleSize, anchor: .center)
            .progressViewStyle(CircularProgressViewStyle(tint: tintColor))
    }
}
