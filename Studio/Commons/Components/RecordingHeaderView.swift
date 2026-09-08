import SwiftUI

struct RecordingHeaderView: View {
    @Binding var recordingState: RecordingState
    @Binding var projectTitle: String
    let elapsedSeconds: Int

    var body: some View {
        switch recordingState {
        case .idle:
            VStack(spacing: 8) {
                Text("Let's Compose Music")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.white)

                HStack {
                    TextField("", text: $projectTitle, prompt:
                                Text("Name this project")
                        .foregroundColor(.white.opacity(0.3))
                    )
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .tint(Color("blue-ribbon-400"))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color.black.opacity(0.3))
                            .overlay(
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                            )
                    )

                    if !projectTitle.isEmpty {
                        Button(action: { projectTitle = "" }, label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.white.opacity(0.3))
                        })
                        .transition(.opacity)
                    }
                }
                .frame(maxWidth: 280)

                Text("Each recording creates a new project if left empty")
                    .font(.system(size: 11))
                    .foregroundColor(.white.opacity(0.4))
                    .multilineTextAlignment(.center)
            }
            .transition(.opacity.combined(with: .scale(scale: 0.95)))

        case .recording, .done:
            VStack(spacing: 8) {
                TextField("Project Name...", text: $projectTitle)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .tint(.white.opacity(0.5))

                Text(formattedTime)
                    .font(.system(size: 32, weight: .semibold, design: .monospaced))
                    .foregroundColor(.white)
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }
        }
    }

    private var formattedTime: String {
        let minutes = elapsedSeconds / 60
        let seconds = elapsedSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
