//
//  WidgetTemplate.swift
//  Beri
//
//  Created by Telmen Bayarbaatar on 8/12/25.
//

import Foundation
import SwiftUI

enum WidgetTemplate: String, CaseIterable, Identifiable, Codable, Equatable {
    case smallStickyNote
    case smallNote
    case smallMathNote
    case smallPolaroid

    case mediumTwoStickyNotes
    case mediumLongNote
    case mediumLongMathNote
    case mediumTwoPolaroids

    case largeStickyNote
    case largePolaroid
    case largeNote
    case largeMathNote

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .smallStickyNote: return "Sticky note"
        case .smallNote: return "Note"
        case .smallMathNote: return "Math note"
        case .smallPolaroid: return "Polaroid"
        case .mediumTwoStickyNotes: return "Sticky notes"
        case .mediumLongNote: return "Note"
        case .mediumLongMathNote: return "Math note"
        case .mediumTwoPolaroids: return "Polaroids"
        case .largeStickyNote: return "Sticky note"
        case .largeNote: return "Note"
        case .largeMathNote: return "Math note"
        case .largePolaroid: return "Polaroid"
        }
    }

    var requiredPhotoCount: Int {
        switch self {
        case .smallPolaroid: return 1
        case .mediumTwoPolaroids: return 2
        case .largePolaroid: return 1
        default: return 0
        }
    }

    static func allowedTemplates(for size: WidgetSize) -> [WidgetTemplate] {
        switch size {
        case .small:
            return [.smallStickyNote, .smallNote, .smallMathNote, .smallPolaroid]
        case .medium:
            return [.mediumTwoStickyNotes, .mediumLongNote, .mediumLongMathNote, .mediumTwoPolaroids]
        case .large:
            return [.largeStickyNote, .largePolaroid, .largeNote, .largeMathNote]
        }
    }
}


