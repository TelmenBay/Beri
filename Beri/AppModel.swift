//
//  AppModel.swift
//  Beri
//
//  Created by Telmen Bayarbaatar on 8/12/25.
//

import SwiftUI

struct UserWidget: Identifiable, Equatable {
    let id: UUID
    var text: String
    var color: Color
    var size: WidgetSize
    var template: WidgetTemplate
    var imageDatas: [Data]
    var createdAt: Date
}

final class AppModel: ObservableObject {
    @Published var selectedTab: Int = 1 // 0 widgets, 1 home, 2 profile
    @Published var widgets: [UserWidget] = []

    func addWidget(text: String, color: Color, size: WidgetSize, template: WidgetTemplate, imageDatas: [Data] = []) {
        let new = UserWidget(
            id: UUID(),
            text: text,
            color: color,
            size: size,
            template: template,
            imageDatas: imageDatas,
            createdAt: Date()
        )
        widgets.insert(new, at: 0)
    }
} 