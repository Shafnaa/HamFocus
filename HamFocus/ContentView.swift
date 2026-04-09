//
//  ContentView.swift
//  HamFocus
//
//  Created by Saujana Shafi on 06/04/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            TabHomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            TabTaskListView()
                .tabItem {
                    Label("Task List", systemImage: "list.bullet")
                }
        }
    }
}

#Preview {
    ContentView().environment(AppViewModel())
        .environmentObject(FocusViewModel())
}
