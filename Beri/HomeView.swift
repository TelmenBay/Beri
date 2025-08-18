//
//  HomeView.swift
//  Beri
//
//  Created by Telmen Bayarbaatar on 8/12/25.
//

import SwiftUI
import UIKit

struct HomeView: View {
    @EnvironmentObject private var model: AppModel
    @State private var showWidgetInfo: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            if model.widgets.isEmpty {
                Spacer()
                Text("No widgets yet. Create one in the Widgets tab.")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                Spacer()
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(model.widgets) { w in
                            WidgetTile(widget: w)
                                .onTapGesture { showWidgetInfo = true }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, 140)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.systemBackground).ignoresSafeArea())
        .alert("Add to Home Screen", isPresented: $showWidgetInfo) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(
                "iOS requires a Widget Extension to place content on the Home Screen. From your Home Screen, long‑press → + → search for the app’s widget, then choose size and place it. This screen is a UI preview; we’ll wire these configurations to the real widget in the extension."
            )
        }
    }
}

private struct WidgetTile: View {
    let widget: UserWidget
    var body: some View {
        VStack {
            WidgetTilePreview(widget: widget)
                .frame(height: 130)
            Text(widget.size.rawValue)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

private struct WidgetTilePreview: View {
    let widget: UserWidget
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(widget.color)
                .shadow(color: .black.opacity(0.12), radius: 10, x: 0, y: 6)

            switch widget.template {
            case .smallStickyNote, .largeStickyNote:
                notePaper
            case .smallNote, .largeNote:
                ruledPaper
            case .smallMathNote, .largeMathNote:
                gridPaper
            case .smallPolaroid, .largePolaroid:
                polaroidStack(maxPhotos: 1)
            case .mediumTwoStickyNotes:
                HStack(spacing: 8) { notePaper; notePaper }
                    .padding(.horizontal, 8)
            case .mediumLongNote:
                ruledPaper
            case .mediumLongMathNote:
                gridPaper
            case .mediumTwoPolaroids:
                polaroidStack(maxPhotos: 2)
            }
        }
    }

    private var notePaper: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.96))
                .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black.opacity(0.08), lineWidth: 1))
                .overlay(
                    Text(widget.text)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.black.opacity(0.85))
                        .multilineTextAlignment(.leading)
                        .padding(12)
                )
            WashiTape().frame(width: 40, height: 12).rotationEffect(.degrees(-12)).offset(x: 6, y: -6)
        }
        .padding(12)
    }

    private var ruledPaper: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.98))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black.opacity(0.08), lineWidth: 1))
                .overlay(alignment: .top) { Rectangle().fill(Color.purple.opacity(0.18)).frame(height: 18).clipShape(RoundedCorner(radius: 10, corners: [.topLeft, .topRight])) }
                .overlay(alignment: .leading) {
                    VStack { Circle().fill(Color.black.opacity(0.1)).frame(width: 8, height: 8); Spacer(); Circle().fill(Color.black.opacity(0.1)).frame(width: 8, height: 8); Spacer(); Circle().fill(Color.black.opacity(0.1)).frame(width: 8, height: 8) }
                        .padding(.vertical, 8)
                        .padding(.leading, 6)
                }
                .overlay(alignment: .topLeading) {
                    VStack(spacing: 10) {
                        Spacer().frame(height: 18)
                        ForEach(0..<8, id: \.self) { _ in Rectangle().fill(Color.purple.opacity(0.15)).frame(height: 1); Spacer() }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                }
                .overlay(
                    Text(widget.text)
                        .font(.system(size: 16))
                        .foregroundStyle(.black.opacity(0.85))
                        .padding(.horizontal, 14)
                        .padding(.top, 10)
                )
        }
        .padding(12)
    }

    private var gridPaper: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.98))
                .overlay {
                    GeometryReader { geo in
                        Path { path in
                            let step: CGFloat = 10
                            for x in stride(from: 0, through: geo.size.width, by: step) { path.move(to: CGPoint(x: x, y: 0)); path.addLine(to: CGPoint(x: x, y: geo.size.height)) }
                            for y in stride(from: 0, through: geo.size.height, by: step) { path.move(to: CGPoint(x: 0, y: y)); path.addLine(to: CGPoint(x: geo.size.width, y: y)) }
                        }
                        .stroke(Color.purple.opacity(0.15), lineWidth: 1)
                    }
                }
                .overlay(
                    Text(widget.text)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.black.opacity(0.9))
                        .multilineTextAlignment(.leading)
                        .padding(10)
                )
                .overlay(alignment: .leading) {
                    VStack(spacing: 8) { ForEach(0..<7, id: \.self) { _ in Circle().stroke(Color.black.opacity(0.2), lineWidth: 1).frame(width: 8, height: 8) } }
                        .padding(.leading, 6)
                }
        }
        .padding(12)
    }

    private func polaroidStack(maxPhotos: Int) -> some View {
        HStack(spacing: 8) {
            ForEach(0..<maxPhotos, id: \.self) { index in
                ZStack(alignment: .bottom) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.black.opacity(0.08), lineWidth: 1)
                        )
                        .overlay {
                            GeometryReader { geo in
                                let footerHeight: CGFloat = 18
                                VStack(spacing: 0) {
                                    ZStack {
                                        if let uiImage = image(at: index) {
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .scaledToFill()
                                        } else {
                                            Color.gray.opacity(0.2)
                                                .overlay(
                                                    Image(systemName: "photo")
                                                        .font(.system(size: 18, weight: .medium))
                                                        .foregroundStyle(.gray)
                                                )
                                        }
                                    }
                                    .frame(width: geo.size.width, height: max(geo.size.height - footerHeight, 0))
                                    .clipped()
                                    Rectangle().fill(Color.white).frame(height: footerHeight)
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                }
            }
        }
        .padding(12)
    }

    private func image(at index: Int) -> UIImage? {
        guard index < widget.imageDatas.count else { return nil }
        return UIImage(data: widget.imageDatas[index])
    }
}

#Preview { HomeView().environmentObject(AppModel()) } 
