import AVFoundation
import Models
import Services
import SwiftUI

struct RecordingNewTakeView: View {
    @State private var recordingState: RecordingState = .idle
    @State private var elapsedSeconds: Int = 0
    @State private var timer: Timer?
    @State private var waveformPhase: Double = 0
    @State private var pulseScale: CGFloat = 1.0
    @State private var showAddFilePopup = false
    @State private var audioRecorder: AVAudioRecorder?
    @State private var recordedAudioURL: URL?
    @State private var waveformAmplitudes: [CGFloat] = (0..<40).map { _ in CGFloat.random(in: 0.1...0.6) }

    private let accentBlue = Color(red: 0.38, green: 0.35, blue: 0.87)
    let returnCard: ProjectCardModel

    var body: some View {
        NavigationStack {
            ZStack {
                NewTakeBackgroundView(accentBlue: accentBlue)

                VStack(spacing: 0) {
                    Spacer()

                    if recordingState != .idle {
                        Text(formattedTime)
                            .font(.system(size: 32, weight: .semibold, design: .monospaced))
                            .foregroundColor(.white)
                            .transition(.opacity.combined(with: .scale(scale: 0.95)))
                            .padding(.bottom, 24)
                    } else {
                        Color.clear.frame(height: 38).padding(.bottom, 24)
                    }

                    NewTakeWaveformView(
                        recordingState: recordingState,
                        waveformAmplitudes: waveformAmplitudes,
                        accentBlue: accentBlue
                    )
                    .padding(.horizontal, 40)
                    .padding(.bottom, 32)

                    NewTakeMicButton(
                        recordingState: recordingState,
                        pulseScale: pulseScale,
                        accentBlue: accentBlue,
                        onTap: handleMicTap
                    )
                    .padding(.bottom, 16)

                    NewTakeActionArea(
                        recordingState: recordingState,
                        showAddFilePopup: $showAddFilePopup,
                        returnCard: returnCard,
                        accentBlue: accentBlue,
                        onReRecord: reRecord
                    )
                    .padding(.bottom, 24)

                    Spacer()
                }
            }
            if showAddFilePopup {
                AddFilePopupView(isPresented: $showAddFilePopup)
                    .zIndex(2)
            }
        }
        .preferredColorScheme(.dark)
    }

    private var formattedTime: String {
        let minutes = elapsedSeconds / 60
        let seconds = elapsedSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    // MARK: - Audio Logic
    private func requestMicrophonePermission() {
        AVAudioApplication.requestRecordPermission { granted in
            if !granted { print("Microphone permission denied") }
        }
    }

    private func setupRecorder() -> URL? {
        let tempDir = FileManager.default.temporaryDirectory
        let fileURL = tempDir.appendingPathComponent("studiobach_newtake_\(UUID().uuidString).m4a")
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
            try session.setActive(true)
            audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
            audioRecorder?.prepareToRecord()
            return fileURL
        } catch {
            print("Failed to set up recorder: \(error)")
            return nil
        }
    }

    private func handleMicTap() {
        withAnimation(.easeInOut(duration: 0.3)) {
            switch recordingState {
            case .idle, .done: startRecording()
            case .recording: stopRecording()
            }
        }
    }

    private func startRecording() {
        requestMicrophonePermission()
        recordingState = .recording
        elapsedSeconds = 0
        pulseScale = 1.0

        if let fileURL = setupRecorder() {
            recordedAudioURL = fileURL
            audioRecorder?.record()
        }

        withAnimation(.easeOut(duration: 1.5).repeatForever(autoreverses: false)) {
            pulseScale = 1.6
        }

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            elapsedSeconds += 1
        }
        startWaveformAnimation()
    }

    private func stopRecording() {
        recordingState = .done
        timer?.invalidate()
        timer = nil
        audioRecorder?.stop()

        withAnimation(.easeOut(duration: 0.3)) {
            waveformAmplitudes = waveformAmplitudes.map { $0 * 0.6 }
        }
    }

    private func reRecord() {
        withAnimation(.easeInOut(duration: 0.3)) {
            recordingState = .idle
            elapsedSeconds = 0
            timer?.invalidate()
            timer = nil
            audioRecorder?.stop()
            if let url = recordedAudioURL {
                try? FileManager.default.removeItem(at: url)
            }
            recordedAudioURL = nil
            waveformAmplitudes = (0..<40).map { _ in CGFloat.random(in: 0.1...0.6) }
        }
    }

    private func startWaveformAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.12, repeats: true) { animTimer in
            DispatchQueue.main.async {
                guard recordingState == .recording else {
                    animTimer.invalidate()
                    return
                }
                var newAmplitudes = waveformAmplitudes
                for i in 0..<newAmplitudes.count {
                    let center = CGFloat(newAmplitudes.count) / 2
                    let distance = abs(CGFloat(i) - center) / center
                    let maxAmp = 1.0 - (distance * 0.5)
                    newAmplitudes[i] = CGFloat.random(in: 0.05...maxAmp)
                }
                waveformAmplitudes = newAmplitudes
            }
        }
    }
}

// MARK: - Extracted Sub-Views

struct NewTakeBackgroundView: View {
    let accentBlue: Color
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.08, green: 0.06, blue: 0.15),
                    Color(red: 0.10, green: 0.08, blue: 0.20),
                    Color(red: 0.06, green: 0.05, blue: 0.12)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            RadialGradient(
                gradient: Gradient(colors: [accentBlue.opacity(0.15), Color.clear]),
                center: .center,
                startRadius: 40,
                endRadius: 300
            )
            .offset(y: 20)
            .ignoresSafeArea()
        }
    }
}

struct NewTakeWaveformView: View {
    let recordingState: RecordingState
    let waveformAmplitudes: [CGFloat]
    let accentBlue: Color

    var body: some View {
        HStack(spacing: 3) {
            ForEach(0..<waveformAmplitudes.count, id: \.self) { index in
                RoundedRectangle(cornerRadius: 2)
                    .fill(
                        LinearGradient(
                            colors: [accentBlue.opacity(0.6), accentBlue, Color.white.opacity(0.7)],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
                    .frame(width: 3, height: barHeight(for: index) + 20)
                    .animation(
                        recordingState == .recording
                        ? .easeInOut(duration: 0.15).delay(Double(index) * 0.01)
                        : .easeInOut(duration: 0.4),
                        value: waveformAmplitudes[index]
                    )
            }
        }
        .frame(height: 100)
    }

    private func barHeight(for index: Int) -> CGFloat {
        let baseHeight: CGFloat = 8
        let maxAdditional: CGFloat = 72
        return baseHeight + waveformAmplitudes[index] * maxAdditional
    }
}

struct NewTakeMicButton: View {
    let recordingState: RecordingState
    let pulseScale: CGFloat
    let accentBlue: Color
    let onTap: () -> Void

    private var micButtonSize: CGFloat {
        switch recordingState {
        case .idle: return 100
        case .recording: return 110
        case .done: return 80
        }
    }

    private var micIconSize: CGFloat {
        switch recordingState {
        case .idle: return 32
        case .recording: return 36
        case .done: return 26
        }
    }

    var body: some View {
        ZStack {
            if recordingState == .recording {
                Circle()
                    .stroke(accentBlue.opacity(0.3), lineWidth: 2)
                    .frame(width: 140, height: 140)
                    .scaleEffect(pulseScale)
                    .opacity(2 - Double(pulseScale))
            }

            if recordingState == .idle || recordingState == .done {
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [accentBlue.opacity(0.5), accentBlue.opacity(0.2)],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        ),
                        lineWidth: 3
                    )
                    .frame(width: recordingState == .done ? 100 : 120, height: recordingState == .done ? 100 : 120)
            }

            Circle()
                .fill(
                    RadialGradient(
                        colors: [accentBlue.opacity(0.9), accentBlue],
                        center: .center, startRadius: 5, endRadius: micButtonSize / 2
                    )
                )
                .frame(width: micButtonSize, height: micButtonSize)
                .shadow(color: accentBlue.opacity(0.5), radius: recordingState == .recording ? 20 : 10, x: 0, y: 0)

            Image(systemName: "mic.fill")
                .font(.system(size: micIconSize, weight: .medium))
                .foregroundColor(.white)
        }
        .onTapGesture { onTap() }
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: recordingState)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
        .accessibilityIdentifier("newTakeMicButton")
    }
}

struct NewTakeActionArea: View {
    let recordingState: RecordingState
    @Binding var showAddFilePopup: Bool
    let returnCard: ProjectCardModel
    let accentBlue: Color
    let onReRecord: () -> Void

    var body: some View {
        switch recordingState {
        case .idle:
            VStack(spacing: 16) {
                Text("TAP TO RECORD")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white.opacity(0.7))
                    .tracking(1.5)

                Button(
                    action: { withAnimation { showAddFilePopup = true } },
                    label: {
                        HStack(spacing: 6) {
                            Image(systemName: "doc.badge.plus")
                                .font(.system(size: 13, weight: .semibold))
                            Text("Add File")
                                .font(.system(size: 13, weight: .semibold))
                        }
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.horizontal, 25)
                        .padding(.vertical, 16)
                        .background(
                            Capsule()
                                .fill(Color.white.opacity(0.1))
                                .overlay(Capsule().stroke(Color.white.opacity(0.2), lineWidth: 1))
                        )
                    }
                )
                .accessibilityIdentifier("addFileButton")
            }
            .transition(.opacity)

        case .recording:
            Color.clear.frame(height: 20)

        case .done:
            HStack(spacing: 16) {
                Button(
                    action: onReRecord,
                    label: {
                        HStack(spacing: 6) {
                            Image(systemName: "arrow.counterclockwise")
                                .font(.system(size: 12, weight: .semibold))
                            Text("Re-Record")
                                .font(.system(size: 13, weight: .semibold))
                        }
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.horizontal, 18)
                        .padding(.vertical, 10)
                        .background(
                            Capsule()
                                .fill(Color.white.opacity(0.1))
                                .overlay(Capsule().stroke(Color.white.opacity(0.2), lineWidth: 1))
                        )
                    }
                )
                .accessibilityIdentifier("reRecordButton")

                NavigationLink(destination: ProjectDetailView(project: returnCard)) {
                    HStack(spacing: 6) {
                        Image(systemName: "play.fill")
                            .font(.system(size: 11, weight: .semibold))
                        Text("Next")
                            .font(.system(size: 13, weight: .semibold))
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
