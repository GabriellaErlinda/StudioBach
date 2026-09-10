import SwiftUI

struct RecordingControlsView: View {
    @Binding var recordingState: RecordingState
    @Binding var showAddFilePopup: Bool
    let pulseScale: CGFloat
    let recordedAudioURL: URL?
    let accentBlue: Color
    let micButtonSize: CGFloat
    let micIconSize: CGFloat
    let onMicTap: () -> Void
    let onReRecord: () -> Void

    var body: some View {
        VStack(spacing: 32) {
            // Microphone Button
            ZStack {
                if recordingState == .recording {
                    Circle()
                        .stroke(accentBlue.opacity(0.3), lineWidth: 2)
                        .frame(width: 140, height: 140)
                        .scaleEffect(pulseScale)
                        .opacity(2 - Double(pulseScale))
                        .animation(
                            .easeOut(duration: 1.5).repeatForever(autoreverses: false),
                            value: pulseScale
                        )
                }

                if recordingState == .idle || recordingState == .done {
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [
                                    accentBlue.opacity(0.5),
                                    accentBlue.opacity(0.2)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 3
                        )
                        .frame(
                            width: recordingState == .done ? 100 : 120,
                            height: recordingState == .done ? 100 : 120
                        )
                }

                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                accentBlue.opacity(0.9),
                                accentBlue
                            ],
                            center: .center,
                            startRadius: 5,
                            endRadius: micButtonSize / 2
                        )
                    )
                    .frame(width: micButtonSize, height: micButtonSize)
                    .shadow(
                        color: accentBlue.opacity(0.5),
                        radius: recordingState == .recording ? 20 : 10,
                        x: 0,
                        y: 0
                    )

                Image(systemName: "mic.fill")
                    .font(.system(size: micIconSize, weight: .medium))
                    .foregroundColor(.white)
            }
            .onTapGesture {
                onMicTap()
            }
            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: recordingState)
            .accessibilityElement(children: .combine)
            .accessibilityAddTraits(.isButton)
            .accessibilityIdentifier("recordMicButton")

            // Action Area
            actionArea
        }
    }

    @ViewBuilder
    private var actionArea: some View {
        switch recordingState {
        case .idle:
            VStack(spacing: 16) {
                Text("TAP TO RECORD")
                    .font(.footnote.bold())
                    .foregroundColor(.white.opacity(1))
                    .tracking(1.5)

                Button(action: {
                    withAnimation {
                        showAddFilePopup = true
                    }
                }, label: {
                    HStack(spacing: 6) {
                        Image(systemName: "doc.badge.plus")
                            .font(.footnote.bold())
                        Text("Add File")
                            .font(.footnote.bold())
                    }
                    .foregroundColor(.white.opacity(1))
                    .padding(.horizontal, 25)
                    .padding(.vertical, 16)
                    .background(
                        Capsule()
                            .fill(Color.white.opacity(0.05))
                            .overlay(Capsule().stroke(Color.white.opacity(0.2), lineWidth: 1))
                    )
                })
                .accessibilityIdentifier("addFileButton")
            }
            .transition(.opacity)

        case .recording:
            Color.clear.frame(height: 20)

        case .done:
            HStack(spacing: 16) {
                Button(action: {
                    onReRecord()
                }, label: {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.footnote.bold())
                        Text("Re-Record")
                            .font(.footnote.bold())
                    }
                    .foregroundColor(.white.opacity(0.9))
                    .padding(.horizontal, 18)
                    .padding(.vertical, 10)
                    .background(
                        Capsule()
                            .fill(Color.white.opacity(0.1))
                            .overlay(
                                Capsule()
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                    )
                })
                .accessibilityIdentifier("reRecordButton")

                NavigationLink(destination: EmotionPickerView(recordedAudioURL: recordedAudioURL).studioNavbar()) {
                    HStack(spacing: 6) {
                        Image(systemName: "play.fill")
                            .font(.footnote.bold())
                        Text("Next")
                            .font(.footnote.bold())
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 22)
                    .padding(.vertical, 10)
                    .background(Capsule().fill(accentBlue))
                }
                .accessibilityIdentifier("nextButton")
            }
            .transition(.opacity.combined(with: .move(edge: .bottom)))
        }
    }
}
