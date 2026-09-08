//
//  projectdetailApp.swift
//  projectdetail
//
//  Created by Rendi Septrian on 03/05/26.
//

import Firebase
import SwiftUI

@main
struct StudioApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
