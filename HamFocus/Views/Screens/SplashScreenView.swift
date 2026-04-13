//
//  SplashScreenView.swift
//  HamFocus
//
//  Created by Matthew Sebastian Lesmana on 13/04/26.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var hamsterOffset: CGFloat = 300
    
    var body: some View {
        ZStack {
            // Background color or image
            Image("BACKGROUND")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // Logo PNG in the middle
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 320)
                    .offset(y:140)
                
                // Subheader PNG just below logo
                Image("subheader")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180)
                    .padding(.top, 8)
                
                Spacer()
                
                // Hamster peeping from the bottom
                Image("HamsterIdle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 600)
                    .offset(y: hamsterOffset) // moves based on state
            }
        }
        .onAppear {
            withAnimation(.spring(duration: 0.8)) {
                hamsterOffset = 60 // slides up into view
            }
        }
    }
}

#Preview {
            SplashScreenView()
        }
