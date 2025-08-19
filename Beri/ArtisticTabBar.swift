//
//  ArtisticTabBar.swift
//  Beri
//
//  Created by Telmen Bayarbaatar on 8/12/25.
//

import SwiftUI

struct ArtisticTabBar: View {
    @Binding var selection: Int // 0 widgets, 1 home, 2 profile
    static let height: CGFloat = 68

    var body: some View {
        ZStack {
            // Full-width solid background for the entire nav section
            Rectangle()
                .fill(Palette.primaryDark)
                .ignoresSafeArea(edges: .bottom)

            // Icons
            HStack {
                tab(icon: "square.grid.2x2", idx: 0)
                Spacer()
                tab(icon: "house.fill", idx: 1)
                Spacer()
                tab(icon: "person", idx: 2)
            }
            .frame(height: ArtisticTabBar.height)
            .padding(.horizontal, 50)
            .offset(y: -4)
        }
        .frame(height: ArtisticTabBar.height)
    }

    @ViewBuilder
    private func tab(icon: String, idx: Int) -> some View {
        Button {
            selection = idx
        } label: {
            Image(systemName: icon)
                .font(.system(size: 25, weight: .semibold))
                .foregroundStyle(selection == idx ? Palette.highlight : Palette.muted)
        }
        .buttonStyle(.plain)
        .contentShape(Rectangle())
    }

    
}

#Preview {
    ZStack(alignment: .bottom) {
        Color(.black).ignoresSafeArea()
        ArtisticTabBar(selection: .constant(1))
    }
} 