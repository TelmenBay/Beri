//
//  BeriApp.swift
//  Beri
//
//  Created by Telmen Bayarbaatar on 8/12/25.
//

import SwiftUI

@main
struct BeriApp: App {
    @State private var didFinishSplash: Bool = false
    var body: some Scene {
        WindowGroup {
            Group {
                if didFinishSplash {
                    ContentView()
                } else {
                    SplashView(isActive: $didFinishSplash)
                        .transition(.opacity)
                }
            }
        }
    }
}
