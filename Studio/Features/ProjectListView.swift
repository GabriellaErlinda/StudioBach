import SwiftUI

struct ProjectListView: View {
    @StateObject var viewModel = ProjectViewModel()
    @State private var isPresentingRecordingView = false
    
    // Warna Hex Sesuai Instruksi
    let themeColor = Color(red: 135/255, green: 153/255, blue: 239/255)       // #8799EF
    let footerProjectColor = Color(red: 85/255, green: 96/255, blue: 247/255) // #5560F7
    
    var body: some View {
        NavigationStack {
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
                
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(viewModel.projects) { project in
                            NavigationLink(destination: ProjectDetailView(project: project)) {
                                ProjectCard(project: project)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .padding(.bottom, 120)
                }
                
                // --- FIXED BUTTON STYLE ---
                HStack {
                    Spacer()
                    Button {
                        isPresentingRecordingView = true
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                            Text("Add New Project")
                                .font(.custom("SF Pro", size: 17).weight(.medium))
                        }
                        .foregroundColor(.white)
                        .padding(.vertical, 16)
                        .padding(.horizontal, 40)
                        .background(Capsule()
                            .fill(Color(red: 0.33, green: 0.38, blue: 0.97).opacity(0.4)))
                        .overlay(
                            Capsule()
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                    }
                    Spacer()
                }
            }
            .navigationDestination(isPresented: $isPresentingRecordingView) {
                RecordingSoundView()
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ProjectListView()
}
