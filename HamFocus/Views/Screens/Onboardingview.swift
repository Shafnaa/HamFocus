//
//  Onboardingview.swift
//  HamFocus
//
//  Created by Raff Melvern Surya Gunawan on 13/04/26.
//

import SwiftUI

struct Onboardingview: View {
    @State private var name = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
        // Title What's your Name
                Text("What's Your Name ?")
                    .font(.largeTitle.bold())
        
        // Gambar Hamster gendut
                Image("HamsterLayDown")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
           
        // Textfill untuk isi nama
                MyTextFieldView()
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 450, height: 80)
                    .padding(.vertical, 10)
               
        // Button untuk OK
                ActionButton(title: "OK") {
                }
                .frame(width: 75, height: 15)
            }
            .padding()
        }
    }
}

#Preview {
    Onboardingview()
}
