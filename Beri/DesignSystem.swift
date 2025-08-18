//
//  DesignSystem.swift
//  Beri
//
//  Created by Telmen Bayarbaatar on 8/12/25.
//

import SwiftUI

enum Palette {
    // Colors inspired by the blueberry logo (primary purple and deep indigo)
    static let primary = Color(red: 0.30, green: 0.28, blue: 0.65)   // ~#4C48A6
    static let primaryDark = Color(red: 0.17, green: 0.16, blue: 0.42) // ~#2B296B
    static let highlight = Color.white
    static let muted = Color.white.opacity(0.6)
}

struct ShadowStyle {
    let color: Color
    let radius: CGFloat
    let y: CGFloat
}

extension View {
    func dsShadow(_ style: ShadowStyle) -> some View {
        shadow(color: style.color, radius: style.radius, x: 0, y: style.y)
    }
} 

// Simple shapes/utilities used by templates
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct TriangleCorner: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

struct WashiTape: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 3)
                .fill(Color.purple.opacity(0.7))
            HStack(spacing: 4) {
                ForEach(0..<6, id: \.self) { _ in
                    Rectangle().fill(Color.white.opacity(0.45)).frame(width: 2)
                }
            }
            .padding(.horizontal, 4)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 3)
                .stroke(Color.black.opacity(0.06), lineWidth: 1)
        )
    }
}