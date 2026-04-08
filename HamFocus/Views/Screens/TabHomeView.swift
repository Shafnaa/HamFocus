//
//  TabHomeView.swift
//  HamFocus
//
//  Created by Heidy Mudita Sutedjo on 08/04/26.
//

import Foundation
import SwiftUI

struct TabHomeView: View {
    var body: some View {
        TaskCarouselView()
    }
}

#Preview {
    TabHomeView().environment(AppViewModel())
}
