//
//  SharedWidgetStorage.swift
//  Beri
//
//  Created by Telmen Bayarbaatar on 8/12/25.
//

import SwiftUI
import Foundation

struct SharedWidgetData: Codable, Equatable {
    var text: String
    var color: RGBAColor
    var sizeRaw: String // WidgetSize.rawValue
    var templateRaw: String // WidgetTemplate.rawValue
    var imageBlobsBase64: [String] // small blobs only for preview sharing
    var createdAt: Date
}

struct RGBAColor: Codable, Equatable {
    var r: Double
    var g: Double
    var b: Double
    var a: Double
}

extension Color {
    init(rgba: RGBAColor) {
        self = Color(red: rgba.r, green: rgba.g, blue: rgba.b).opacity(rgba.a)
    }

    func toRGBA() -> RGBAColor {
        #if canImport(UIKit)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        UIColor(self).getRed(&r, green: &g, blue: &b, alpha: &a)
        return RGBAColor(r: Double(r), g: Double(g), b: Double(b), a: Double(a))
        #else
        return RGBAColor(r: 0.3, g: 0.3, b: 0.3, a: 1)
        #endif
    }
}

enum WidgetStorage {
    private static let latestKey = "latest_widget"

    private static var defaults: UserDefaults? {
        UserDefaults(suiteName: AppGroup.id)
    }

    static func saveLatest(text: String, color: Color, size: WidgetSize, template: WidgetTemplate, imageDatas: [Data]) {
        let dataModel = SharedWidgetData(
            text: text,
            color: color.toRGBA(),
            sizeRaw: size.rawValue,
            templateRaw: template.rawValue,
            imageBlobsBase64: imageDatas.map { $0.base64EncodedString() },
            createdAt: Date()
        )
        guard let encoded = try? JSONEncoder().encode(dataModel) else { return }
        defaults?.set(encoded, forKey: latestKey)
    }

    static func loadLatest() -> SharedWidgetData? {
        guard let data = defaults?.data(forKey: latestKey) else { return nil }
        return try? JSONDecoder().decode(SharedWidgetData.self, from: data)
    }
} 