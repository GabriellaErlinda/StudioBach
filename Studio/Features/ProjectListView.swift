import Models
import Services
import SwiftUI

enum ProjectRoute: Hashable {
    case detail(ProjectCardModel)
    case newRecording
    case newTake(ProjectCardModel)
}

struct ProjectListView: View {
    @State var viewModel = ProjectViewModel()
    @State private var path = NavigationPath()
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
        NavigationStack(path: $path) {
            VStack(spacing: 0) {
                HStack {
                    Text("PROJECTS")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.horizontal, 25)
                .padding(.top, 30)
                .padding(.bottom, 10)
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(viewModel.projects) { project in
                            NavigationLink(value: ProjectRoute.detail(project)) {
                                ProjectCard(project: project)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .padding(.bottom, 120)
                }
                HStack {
                    Spacer()
                    Button {
                        path.append(ProjectRoute.newRecording)
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                            Text("Add New Project")
                                .font(.body)
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
                    .accessibilityIdentifier("addNewProjectButton")
                    Spacer()
                }
                .offset(y: -30)
            }
            .navigationDestination(for: ProjectRoute.self) { route in
                switch route {
                case .detail(let project):
                    ProjectDetailView(project: project, path: $path)
                case .newRecording:
                    RecordingSoundView().studioNavbar()
                case .newTake(let project):
                    RecordingNewTakeView(returnCard: project)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ProjectListView()
}
