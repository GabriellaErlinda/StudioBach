//
//  ContentView.swift
//  Minty
//
//  Created by User on 22/04/26.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        Button("Test Crash") {
            fatalError("Crashlytics Test Crash")
        }
        
        TabView(selection: $selectedTab) {
            NavigationStack {
                RecordingSoundView()
                    .studioNavbar()
            }
            .tabItem {
                Label("Record", systemImage: "microphone.fill")
            }
            .tag(0)
            
            NavigationStack {
                ProjectListView()
                    .studioNavbar()
            }
            .tabItem {
                Label("Projects", systemImage: "folder.fill")
            }
            .tag(1)
        }
        .tint(Color(red: 0.6078431372549019, green: 0.6862745098039216, blue: 1))
    }
}

#Preview {
    ContentView()
}
