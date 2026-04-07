//
//  TextFieldView.swift
//  HamFocus
//
//  Created by Saujana Shafi on 07/04/26.
//

import Foundation
import SwiftUI

struct MyTextFieldView: View {
    @State private var text = "Type Here"

    var body: some View {
        VStack {
            TextField("Enter text here...", text: $text)
                .padding() // makes it thicker
                .background(Color.white.opacity(0.2)) // soft background
                .cornerRadius(25) // more rounded (pill shape)
                .padding(.horizontal) // space from screen edge
        }
    }
}

#Preview {
    MyTextFieldView()
}
