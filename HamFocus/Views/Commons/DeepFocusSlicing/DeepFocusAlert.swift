//
//  DeepFocusAlert.swift
//  HamFocus
//
//  Created by Raff Melvern Surya Gunawan on 09/04/26.
//

import SwiftUI

//Alert Button untuk ketika selesai task
struct DeepFocusAlert<Content: View>: View {
    @EnvironmentObject var focusVM : FocusViewModel
    private let content: Content
    @Binding var isPresented : Bool
    init(
        isPresented: Binding<Bool>,
        @ViewBuilder content: () -> Content,
    ) {
        _isPresented = isPresented

        self.content = content()
    }
    var body: some View {
        content
        
        .alert("Focus Session Complete", isPresented: $isPresented) {
            Button("Back",) {
                isPresented.toggle()
            }
            Button("Finish", role: .confirm) {
                focusVM.stopFocusMode(done: true)
            }
        } message: {
            Text("Your focus session was \(focusVM.elapsedTime)")
        }
    }
}

#Preview {
    DeepFocusAlert(isPresented: .constant(true), content: { Button("muncul") {
        
    }})
    .environmentObject(FocusViewModel())
}
