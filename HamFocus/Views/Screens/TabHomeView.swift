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
        NavigationStack {
            VStack {
                TaskCarouselView()
                ActionButton(title: "Start", iconName: "play.fill") {
                    
                }
                .padding(.horizontal, 100)
                .padding(.vertical, 10)
            }
            .navigationTitle(Text("Space"))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    TabHomeView().environment(AppViewModel())
}
