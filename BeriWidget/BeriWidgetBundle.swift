//
//  BeriWidgetBundle.swift
//  BeriWidget
//
//  Created by Telmen Bayarbaatar on 8/17/25.
//

import WidgetKit
import SwiftUI

@main
struct BeriWidgetBundle: WidgetBundle {
    var body: some Widget {
        BeriWidget()
        BeriWidgetControl()
        BeriWidgetLiveActivity()
    }
}
