import AVFoundation
import SwiftUI

enum RecordingState {
    case idle
    case recording
    case done
}

struct RecordingSoundView: View {
    @State private var recordingState: RecordingState = .idle
    @State private var elapsedSeconds: Int = 0
    @State private var timer: Timer?
    @State private var pulseScale: CGFloat = 1.0
    @State private var showAddFilePopup = false

    @State private var projectTitle: String = ""
    @State private var audioRecorder: AVAudioRecorder?
    @State private var recordedAudioURL: URL?

    @State private var waveformAmplitudes: [CGFloat] = (0..<40).map { _ in CGFloat.random(in: 0.1...0.6) }
    private let accentBlue = Color(red: 0.38, green: 0.35, blue: 0.87)

    var body: some View {
        ZStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color("blue-ribbon-900"),
                        Color("blue-ribbon-950"),
                        Color("primary-950")
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                RadialGradient(
                    gradient: Gradient(colors: [
                        Color("blue-ribbon-600").opacity(0.5),
                        Color("blue-ribbon-800").opacity(0.5),
                        Color.clear
                    ]),
                    center: .center,
                    startRadius: 40,
                    endRadius: 300
                )
                .offset(y: 20)
                .ignoresSafeArea()

                VStack(spacing: 0) {
                    Spacer()

                    RecordingHeaderView(
                        recordingState: $recordingState,
                        projectTitle: $projectTitle,
                        elapsedSeconds: elapsedSeconds
                    )
                    .padding(.bottom, 24)

                    RecordingWaveformView(
                        recordingState: recordingState,
                        waveformAmplitudes: waveformAmplitudes
                    )
                    .padding(.horizontal, 40)
                    .padding(.bottom, 32)

                    RecordingControlsView(
                        recordingState: $recordingState,
                        showAddFilePopup: $showAddFilePopup,
                        pulseScale: pulseScale,
                        recordedAudioURL: recordedAudioURL,
                        accentBlue: accentBlue,
                        micButtonSize: micButtonSize,
                        micIconSize: micIconSize,
                        onMicTap: handleMicTap,
                        onReRecord: reRecord
                    )
                    .padding(.bottom, 40)

                    if recordingState == .idle || recordingState == .done {
                        existingProjectLink
                            .padding(.top, 22)
                    }

                    Spacer()
                }
                .offset(y: -60)
            }

            if showAddFilePopup {
                AddFilePopupView(isPresented: $showAddFilePopup)
                    .zIndex(2)
            }
        }
        .ignoresSafeArea(.keyboard)
    }

    private var existingProjectLink: some View {
        NavigationLink {
            ProjectListView().studioNavbar()
        } label: {
            Text("RECORD TO EXISTING PROJECT?")
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.white.opacity(0.4))
                .tracking(1)
        }
    }

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

    private func requestMicrophonePermission() {
        AVAudioApplication.requestRecordPermission { granted in
            if !granted {
                print("Microphone permission denied")
            }
        }
    }

    private func setupRecorder() -> URL? {
        let tempDir = FileManager.default.temporaryDirectory
        let fileURL = tempDir.appendingPathComponent("studiobach_recording_\(UUID().uuidString).m4a")

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
            case .idle, .done:
                startRecording()
            case .recording:
                stopRecording()
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

#Preview {
    RecordingSoundView()
}
