//
//  ContentView.swift
//  Beri
//
//  Created by Telmen Bayarbaatar on 8/12/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var model = AppModel()

    var body: some View {
        TabView(selection: $model.selectedTab) {
            WidgetsView()
                .tag(0)
            HomeView()
                .tag(1)
            ProfileView()
                .tag(2)
        }
        .environmentObject(model)
        .tabViewStyle(.page(indexDisplayMode: .never))
        .overlay(alignment: .bottom) {
            ArtisticTabBar(selection: $model.selectedTab)
                .ignoresSafeArea(edges: .bottom)
        }
    }
}

#Preview {
    ContentView()
}
