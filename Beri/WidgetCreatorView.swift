//
//  WidgetCreatorView.swift
//  Beri
//
//  Created by Telmen Bayarbaatar on 8/12/25.
//

import SwiftUI
import UIKit

enum WidgetSize: String, CaseIterable, Identifiable {
    case small = "Small"
    case medium = "Medium"
    case large = "Large"
    var id: String { rawValue }

    var previewSize: CGSize {
        switch self {
        case .small: return CGSize(width: 120, height: 120)
        case .medium: return CGSize(width: 240, height: 120)
        case .large: return CGSize(width: 240, height: 240)
        }
    }
}

// MARK: - Small subviews to ease type-checker

private struct StickyNoteCard: View {
    let text: String
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.96))
                .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black.opacity(0.08), lineWidth: 1))
                .overlay(alignment: .bottomTrailing) {
                    TriangleCorner()
                        .fill(Color.white)
                        .frame(width: 20, height: 20)
                        .shadow(color: .black.opacity(0.06), radius: 2, x: -1, y: -1)
                        .offset(x: -4, y: -4)
                }
                .overlay(
                    Text(text)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.black.opacity(0.85))
                        .multilineTextAlignment(.leading)
                        .padding(12)
                )
            WashiTape().frame(width: 46, height: 14).rotationEffect(.degrees(-15)).offset(x: 6, y: -6)
        }
        .padding(12)
    }
}

private struct RuledNoteCard: View {
    let text: String
    var body: some View {
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
                    VStack(spacing: 10) { Spacer().frame(height: 18); ForEach(0..<8, id: \.self) { _ in Rectangle().fill(Color.purple.opacity(0.15)).frame(height: 1); Spacer() } }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                }
                .overlay(
                    Text(text)
                        .font(.system(size: 16))
                        .foregroundStyle(.black.opacity(0.85))
                        .padding(.horizontal, 14)
                        .padding(.top, 10)
                )
        }
        .padding(12)
    }
}

private struct GridNoteCard: View {
    let text: String
    var body: some View {
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
                    Text(text)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.black.opacity(0.9))
                        .padding(12)
                )
                .overlay(alignment: .leading) {
                    VStack(spacing: 8) { ForEach(0..<7, id: \.self) { _ in Circle().stroke(Color.black.opacity(0.2), lineWidth: 1).frame(width: 8, height: 8) } }
                        .padding(.leading, 6)
                }
        }
        .padding(12)
    }
}

private struct PolaroidStrip: View {
    let images: [UIImage]
    let count: Int
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<count, id: \.self) { index in
                PolaroidCard(image: index < images.count ? images[index] : nil)
                    .rotationEffect(.degrees(count == 2 ? (index == 0 ? -2 : 2) : 0))
            }
        }
        .padding(12)
    }
}

private struct PolaroidCard: View {
    let image: UIImage?
    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.black.opacity(0.08), lineWidth: 1))
                .overlay {
                    GeometryReader { geo in
                        let footerHeight: CGFloat = 18
                        VStack(spacing: 0) {
                            ZStack {
                                if let image = image {
                                    Image(uiImage: image).resizable().scaledToFill()
                                } else {
                                    Color.gray.opacity(0.15).overlay(Image(systemName: "photo").font(.system(size: 18)).foregroundStyle(.gray))
                                }
                            }
                            .frame(width: geo.size.width, height: max(geo.size.height - footerHeight, 0))
                            .clipped()
                            Rectangle().fill(Color.white).frame(height: footerHeight)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            WashiTape().frame(width: 34, height: 12).rotationEffect(.degrees(-8)).offset(y: -6)
        }
    }
}

struct WidgetCreatorView: View {
    @EnvironmentObject private var model: AppModel

    @State private var widgetText: String = "My Widget"
    @State private var selectedSize: WidgetSize = .small
    @State private var selectedTemplate: WidgetTemplate = .smallStickyNote
    @State private var pickedImages: [UIImage] = []
    @State private var showImagePicker: Bool = false
    @State private var imagePickerIndexToFill: Int? = nil

    // Removed color swatches; color is no longer user-selectable

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Live Preview
            Text("Preview")
                .font(.headline)
                .padding(.horizontal, 4)
            WidgetPreview(color: Palette.primary, text: widgetText, size: selectedSize, template: selectedTemplate, images: pickedImages)
                .frame(maxWidth: .infinity)

            // Size Picker
            Text("Size")
                .font(.headline)
                .padding(.horizontal, 4)
            Picker("Size", selection: $selectedSize) {
                ForEach(WidgetSize.allCases) { size in
                    Text(size.rawValue).tag(size)
                }
            }
            .pickerStyle(.segmented)

            // Template Picker
            Text("Template")
                .font(.headline)
                .padding(.horizontal, 4)
            templateGrid

            // Text Input
            Text("Text")
                .font(.headline)
                .padding(.horizontal, 4)
            TextField("Enter text", text: $widgetText)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            // Color selector removed

            // Actions (UI only)
            HStack {
                Button("Reset") {
                    widgetText = "My Widget"
                    selectedSize = .small
                    selectedTemplate = WidgetTemplate.allowedTemplates(for: selectedSize).first ?? .smallStickyNote
                    pickedImages = []
                }
                .buttonStyle(.bordered)

                Spacer()

                Button("Save") {
                    // Save to local app model
                    let imageDatas = pickedImages.compactMap { $0.jpegData(compressionQuality: 0.9) }
                    model.addWidget(text: widgetText, color: Palette.primary, size: selectedSize, template: selectedTemplate, imageDatas: imageDatas)
                    // Persist latest to App Group for WidgetKit
                    WidgetStorage.saveLatest(text: widgetText, color: Palette.primary, size: selectedSize, template: selectedTemplate, imageDatas: imageDatas)
                    // Switch to Home
                    model.selectedTab = 1
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .onChange(of: selectedSize) { newSize in
            // Adjust template to a sensible default for the selected size
            selectedTemplate = WidgetTemplate.allowedTemplates(for: newSize).first ?? selectedTemplate
            // Reset images when switching sizes/templates
            pickedImages = []
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePickerView(allowsMultipleSelection: false) { image in
                if let index = imagePickerIndexToFill, let image = image {
                    setPickedImage(image, at: index)
                }
            }
        }
    }
}

private struct WidgetPreview: View {
    // Color is fixed to primary to maintain contrast with full-bleed templates
    let color: Color
    let text: String
    let size: WidgetSize
    var template: WidgetTemplate? = nil
    var images: [UIImage] = []

    var body: some View {
        VStack {
            // Full-bleed preview clipped with a subtle border
            templateOverlay
                .frame(width: size.previewSize.width, height: size.previewSize.height)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.purple.opacity(0.18), lineWidth: 1)
                )
        }
        .frame(maxWidth: .infinity)
    }

    private var contrastColor: Color {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        UIColor(color).getRed(&r, green: &g, blue: &b, alpha: &a)
        let luminance = 0.2126 * r + 0.7152 * g + 0.0722 * b
        return luminance > 0.6 ? .black : .white
    }

    @ViewBuilder
    private var templateOverlay: some View {
        switch template ?? .smallStickyNote {
        case .smallStickyNote, .largeStickyNote:
            StickyNoteCard(text: text)
        case .smallNote, .largeNote:
            RuledNoteCard(text: text)
        case .smallMathNote, .largeMathNote:
            GridNoteCard(text: text)
        case .smallPolaroid, .largePolaroid:
            PolaroidStrip(images: images, count: 1)
        case .mediumTwoStickyNotes:
            HStack(spacing: 8) {
                StickyNoteCard(text: text).rotationEffect(.degrees(-2)).offset(y: 2)
                StickyNoteCard(text: text).rotationEffect(.degrees(3)).offset(y: -2)
            }
            .padding(8)
        case .mediumLongNote:
            RuledNoteCard(text: text)
        case .mediumLongMathNote:
            GridNoteCard(text: text)
        case .mediumTwoPolaroids:
            PolaroidStrip(images: images, count: 2)
        }
    }
}

// MARK: - Template Grid and Image Picker

extension WidgetCreatorView {
    private var templateGrid: some View {
        let options = WidgetTemplate.allowedTemplates(for: selectedSize)
        return VStack(alignment: .leading, spacing: 8) {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(options) { option in
                    Button {
                        selectedTemplate = option
                        pickedImages = []
                    } label: {
                        HStack(spacing: 8) {
                            templateIcon(option)
                            Text(option.displayName)
                                .font(.subheadline)
                                .foregroundStyle(.primary)
                            Spacer()
                        }
                        .padding(10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedTemplate == option ? Color.accentColor : Color.gray.opacity(0.25), lineWidth: 1)
                        )
                    }
                }
            }

            // Polaroid image pickers if needed
            if selectedTemplate.requiredPhotoCount > 0 {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 4) {
                        Text("Photos (")
                        Text("\(pickedImages.count)/\(selectedTemplate.requiredPhotoCount)").bold()
                        Text(")")
                    }
                    HStack(spacing: 12) {
                        ForEach(0..<selectedTemplate.requiredPhotoCount, id: \.self) { idx in
                            Button {
                                imagePickerIndexToFill = idx
                                showImagePicker = true
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color(UIColor.secondarySystemBackground))
                                        .frame(width: 68, height: 68)
                                    if idx < pickedImages.count {
                                        Image(uiImage: pickedImages[idx])
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 68, height: 68)
                                            .clipped()
                                    } else {
                                        Image(systemName: "plus")
                                            .font(.system(size: 18, weight: .semibold))
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.top, 2)
                    Text("Max 5 MB each. JPEG/PNG")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 4)
            }
        }
    }

    private func templateIcon(_ template: WidgetTemplate) -> some View {
        let name: String
        switch template {
        case .smallStickyNote, .mediumTwoStickyNotes, .largeStickyNote: name = "note.text"
        case .smallNote, .mediumLongNote, .largeNote: name = "list.bullet.rectangle"
        case .smallMathNote, .mediumLongMathNote, .largeMathNote: name = "function"
        case .smallPolaroid, .mediumTwoPolaroids, .largePolaroid: name = "photo"
        }
        return Image(systemName: name)
            .font(.system(size: 16, weight: .medium))
            .foregroundStyle(.secondary)
    }

    private func setPickedImage(_ image: UIImage, at index: Int) {
        // Enforce 5 MB limit
        let compressed = image.jpegData(compressionQuality: 0.9) ?? image.pngData()
        if let data = compressed, data.count <= 5 * 1024 * 1024 {
            if index < pickedImages.count {
                pickedImages[index] = UIImage(data: data) ?? image
            } else {
                // Fill until index
                while pickedImages.count < index { pickedImages.append(UIImage()) }
                if let u = UIImage(data: data) { pickedImages.append(u) }
            }
        }
    }
}

// Simple UIKit wrapper for single image picking
struct ImagePickerView: UIViewControllerRepresentable {
    var allowsMultipleSelection: Bool = false
    var onPick: (UIImage?) -> Void

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        picker.mediaTypes = ["public.image"]
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePickerView
        init(_ parent: ImagePickerView) { self.parent = parent }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) { parent.onPick(nil); picker.dismiss(animated: true) }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let image = (info[.editedImage] ?? info[.originalImage]) as? UIImage
            parent.onPick(image)
            picker.dismiss(animated: true)
        }
    }
}

#Preview { WidgetCreatorView().environmentObject(AppModel()) }