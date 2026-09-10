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
                    .font(.title3.bold())
                    .foregroundColor(.white)
                    .fixedSize(horizontal: false, vertical: true)

                HStack {
                    TextField("", text: $projectTitle, prompt:
                                Text("Name this project")
                        .foregroundColor(.white.opacity(1)),
                              axis: .vertical // allow vertical growth instead of clipping
                    )
                    .font(.subheadline.bold())
                    .lineLimit(1...3) // caps how tall it can grow, still avoids clipping
                    .frame(minHeight: 44)
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
                                .foregroundColor(.white.opacity(1))
                        })
                        .transition(.opacity)
                        .frame(minWidth: 44, minHeight: 44)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 24)

                Text("Each recording creates a new project if left empty")
                    .font(.caption)
                    .foregroundColor(.white.opacity(1))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .transition(.opacity.combined(with: .scale(scale: 0.95)))

        case .recording, .done:
            VStack(spacing: 8) {
                TextField("Project Name...", text: $projectTitle, axis: .vertical)
                    .font(.headline)
                    .foregroundColor(.white.opacity(1))
                    .multilineTextAlignment(.center)
                    .tint(.white.opacity(0.5))
                    .lineLimit(1...2)
                    .padding(.horizontal, 24)

                Text(formattedTime)
                    .font(.title3.bold().monospaced())
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
