//
//  ArtisticTabBar.swift
//  Beri
//
//  Created by Telmen Bayarbaatar on 8/12/25.
//

import SwiftUI

struct ArtisticTabBar: View {
    @Binding var selection: Int // 0 widgets, 1 home, 2 profile

    var body: some View {
        ZStack {
            // Solid purple bar (no glass/blur)
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Palette.primaryDark)
                .frame(height: 68)
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(Palette.primary.opacity(0.45), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.2), radius: 14, x: 0, y: 8)
                .padding(.horizontal, 16)
                .padding(.bottom, 8)

            // Icons
            HStack {
                tab(icon: "square.grid.2x2", idx: 0)
                Spacer()
                tab(icon: "house.fill", idx: 1)
                Spacer()
                tab(icon: "person", idx: 2)
            }
            .frame(height: 68)
            .padding(.horizontal, 50)
            .offset(y: -4) 
            
        }
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