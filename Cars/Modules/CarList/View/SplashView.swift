//
//  SplashView.swift
//  Cars
//
//  Created by Linkon Sid on 21/12/22.
//

import SwiftUI

struct SplashView: View {
    @State var isActive = false

    var body: some View {
        VStack {
            if self.isActive {
                CarListRouter.createModule()
            } else {
                Image(AppConstants.Image.Splash)
                    .resizable()
                    .scaledToFit()
            }
        }
        .onAppear {
            // load main view after 2 sec
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
