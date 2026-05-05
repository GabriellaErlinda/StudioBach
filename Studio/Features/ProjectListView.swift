import SwiftUI

struct ProjectListView: View {
    @StateObject var viewModel = ProjectViewModel()
    @State private var isPresentingRecordingView = false
    
    let themeColor = LinearGradient(
        gradient: Gradient(colors: [
            Color("blue-ribbon-900"),
            Color("blue-ribbon-950"),
            Color("primary-950")
        ]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    let footerProjectColor = Color(red: 85/255, green: 96/255, blue: 247/255) // #5560F7
    
    var body: some View {
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
                            .fill(Color("blue-ribbon-400")))
                        .overlay(
                            Capsule()
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                    }
                    Spacer()
                }
                .offset(y: -30)
            }
            .navigationDestination(isPresented: $isPresentingRecordingView) {
                RecordingSoundView()
                    .studioNavbar()
            }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ProjectListView()
}
