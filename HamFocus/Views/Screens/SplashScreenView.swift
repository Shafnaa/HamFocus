//
//  SplashScreenView.swift
//  HamFocus
//
//  Created by Matthew Sebastian Lesmana on 13/04/26.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var logoOpacity: CGFloat = 0
    @State private var logoOffset: CGFloat = -20
    @State private var subheaderOpacity: CGFloat = 0
    @State private var hamsterOffset: CGFloat = 500
    
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
                Image("LogoNew")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 340)
                    .opacity(logoOpacity)
                    .offset(y:logoOffset)
                    .frame(maxWidth: .infinity)
                
                // Subheader PNG just below logo
                Text("Stay on the wheel !")
                    .font(.custom("YourFontName", size: 23).weight(.black))
                    .bold()
                    .foregroundColor(.white)
                    .opacity(subheaderOpacity)
                    .padding(.top, 4)
                
                Spacer()
                
                // Hamster peeping from the bottom
                Image("HamsterIdleFix")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 640)
                    .offset(y: hamsterOffset) // moves based on state
                    .frame(maxWidth: .infinity)
            }
        }
        .onAppear {
            // Logo appears first
            withAnimation(.easeOut(duration: 0.6)) {
                logoOpacity = 1
                logoOffset = 0
            }

            // Subheader appears shortly after
            withAnimation(.easeOut(duration: 0.5).delay(0.4)) {
                subheaderOpacity = 1
                        }
            withAnimation(.spring(duration: 1).delay(0.9)) {
                hamsterOffset = 150 // slides up into view
            }
        }
    }
}

#Preview {
            SplashScreenView()
        }
