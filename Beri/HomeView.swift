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
        ZStack {

            if model.widgets.isEmpty {
                Spacer()
                Text("No widgets yet. Create one in the Widgets tab.")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                Spacer()
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        widgetSection(title: "Small", size: .small)
                        widgetSection(title: "Medium", size: .medium)
                        widgetSection(title: "Large", size: .large)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, ArtisticTabBar.height + 16)
                    // Rely on safeAreaInset from the custom tab bar to provide bottom spacing
                }
                .contentMargins(.bottom, 0, for: .scrollContent)
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
                .frame(width: widget.size.previewSize.width, height: widget.size.previewSize.height)
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
                HStack(spacing: 8) {
                    notePaper.frame(maxWidth: .infinity, maxHeight: .infinity)
                    notePaper.frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            case .mediumLongNote:
                ruledPaper
            case .mediumLongMathNote:
                gridPaper
            case .mediumTwoPolaroids:
                polaroidStack(maxPhotos: 2)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.purple.opacity(0.18), lineWidth: 1)
        )
    }

    private var notePaper: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.96))
                .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
                .overlay(
                    Text(widget.text)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.black.opacity(0.85))
                        .multilineTextAlignment(.leading)
                        .padding(12)
                )
            WashiTape().frame(width: 40, height: 12).rotationEffect(.degrees(-12)).offset(x: 6, y: -6)
        }
    }

    private var ruledPaper: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.98))
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

// MARK: - Sections

private extension HomeView {
    @ViewBuilder
    func widgetSection(title: String, size: WidgetSize) -> some View {
        let items = model.widgets.filter { $0.size == size }
        if !items.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                Text(title)
                    .font(.headline)
                LazyVGrid(columns: gridColumns(for: size), spacing: 16) {
                    ForEach(items) { w in
                        WidgetTile(widget: w)
                            .onTapGesture { showWidgetInfo = true }
                    }
                }
            }
        }
    }

    func gridColumns(for size: WidgetSize) -> [GridItem] {
        switch size {
        case .small:
            return [GridItem(.adaptive(minimum: 136), spacing: 16, alignment: .top)]
        case .medium, .large:
            return [GridItem(.adaptive(minimum: 252), spacing: 16, alignment: .top)]
        }
    }
}

#Preview { HomeView().environmentObject(AppModel()) } 
