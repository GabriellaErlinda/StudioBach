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
        
        TabView(selection: $selectedTab) {
            NavigationStack {
                SongResultsView()
                    .toolbar {
                        primaryToolbarItems()
                    }
            }
            .tabItem {
                Label("Record", systemImage: "microphone.fill")
            }
            .tag(0)
            
            NavigationStack {
                ProjectListView()
                    .toolbar {
                        primaryToolbarItems()
                    }
            }
            .tabItem {
                Label("Projects", systemImage: "folder.fill")
            }
            .tag(1)
        }
        .tint(Color(red: 0.6078431372549019, green: 0.6862745098039216, blue: 1))
    }
    
    @ToolbarContentBuilder
    func primaryToolbarItems() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button(action: { }) {
                Label("Back", systemImage: "chevron.backward")
                    .labelStyle(.iconOnly)
            }
        }
        ToolbarItem(placement: .principal) {
            Text("STUDIO")
                .foregroundStyle(Color(red: 0.5294117647058824, green: 0.6, blue: 0.9372549019607843))
                .fontWeight(.bold)
                .font(.system(size: 20))
        }
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: {}) {
                Label("Info", systemImage: "info")
                    .labelStyle(.iconOnly)
            }
        }
    }
}
#Preview {
    ContentView()
}
