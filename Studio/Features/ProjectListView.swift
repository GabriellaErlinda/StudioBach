//
//  ProjectList.swift
//  Studio
//
//  Created by Gabriella Erlinda on 04/05/26.
//

import SwiftUI

struct ProjectListView: View {
    @StateObject var viewModel = ProjectViewModel()
    
    // Warna Hex Sesuai Instruksi
    let themeColor = Color(red: 135/255, green: 153/255, blue: 239/255)       // #8799EF
    let footerProjectColor = Color(red: 85/255, green: 96/255, blue: 247/255) // #5560F7
    
    var body: some View {
        // Pembungkus utama untuk navigasi
        VStack(spacing: 0) {
            
            HStack {
                Text("PROJECTS")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.horizontal, 25)
            .padding(.top, 30)
            .padding(.bottom, 10)
            
            // --- LIST PROJECTS SEBAGAI TOMBOL NAVIGASI ---
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(viewModel.projects) { project in
                        // NavigationLink membungkus kartu agar bisa dipencet
                        NavigationLink(destination: ProjectDetailView(project: project)) {
                            ProjectCard(project: project)
                        }
                        .buttonStyle(PlainButtonStyle()) // Menjaga warna asli kartu (tidak jadi biru)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 120)
            }
        }
        .preferredColorScheme(.dark)
    }
}



#Preview {
    ProjectListView()
}
