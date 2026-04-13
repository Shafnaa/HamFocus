//
//  FocusWidgetBundle.swift
//  FocusWidget
//
//  Created by Felicia Joshlyn Purnomo on 12/04/26.
//

import WidgetKit
import SwiftUI

@main
struct FocusWidgetBundle: WidgetBundle {
    var body: some Widget {
        FocusWidget()
        FocusWidgetControl()
        FocusWidgetLiveActivity()
    }
}
