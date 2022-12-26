//
//  CarsApp.swift
//  Cars
//
//  Created by Linkon Sid on 16/12/22.
//

import SwiftUI


//struct MainApp {
//    static func main() {
//
//                if #available(iOS 14.0, *) {
//                    CarsApp.main()
//                }
//                else {
//                    UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(SceneDelegate.self))
//                }
//            }
//}

@main
struct CarsApp:App{
    init(){
        DIManager.shared.registerAllDependencies()
    }
    var body: some Scene {
        WindowGroup {
            SplashView()
        }
    }
}
