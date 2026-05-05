//
//  RecordingSoundView.swift
//  airbach
//
//  Created by Farrell Habibie Putra Haris pagi pagi di teras academy tanggal 04/05/26
//

import SwiftUI
import AVFoundation

// state
enum RecordingState {
    case idle
    case recording
    case done
}

// view
struct RecordingSoundView: View {
    @State private var recordingState: RecordingState = .idle
    @State private var elapsedSeconds: Int = 0
    @State private var timer: Timer?
    @State private var waveformPhase: Double = 0
    @State private var pulseScale: CGFloat = 1.0
    @State private var showAddFilePopup = false
    @State private var projectTitle: String = ""
    
    // Audio recording
    @State private var audioRecorder: AVAudioRecorder?
    @State private var recordedAudioURL: URL?
    
    // waveform amplitudes
    @State private var waveformAmplitudes: [CGFloat] = (0..<40).map { _ in CGFloat.random(in: 0.1...0.6) }
    
    private let accentBlue = Color(red: 0.38, green: 0.35, blue: 0.87) // color code -> #615ADE
    
    var body: some View {
        ZStack {
            ZStack {
                // Background gradient
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
                
                // radial glow ala ala dibawah mic
                RadialGradient(
                    gradient: Gradient(colors: [
                        accentBlue.opacity(0.15),
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
                    
                    // Title or Timer
                    headerContent
                        .padding(.bottom, 24)
                    
                    // Waveform Visualization
                    waveformView
                        .padding(.horizontal, 40)
                        .padding(.bottom, 32)
                    
                    // Microphone Button
                    microphoneButton
                        .padding(.bottom, 40)
                    
                    // Action Area (TAP TO RECORD / Re-Record & Next)
                    actionArea
                        .padding(.bottom, 24)
                    
                    // Record to Existing Project
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
        .preferredColorScheme(.dark)
    }
    
    
    
    // Header Content
    @ViewBuilder
    private var headerContent: some View {
        switch recordingState {
        case .idle:
            VStack(spacing: 8) { // Adjust spacing as needed
                Text("Let's Compose Music")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.white)
                
                TextField("Input Project Name...", text: $projectTitle)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .tint(.white.opacity(0.5))
            }
            .transition(.opacity.combined(with: .scale(scale: 0.95)))
                
        case .recording, .done:
            VStack(spacing: 8) { // Adjust spacing as needed
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
    
    // Waveform View
    private var waveformView: some View {
        HStack(spacing: 3) {
            ForEach(0..<waveformAmplitudes.count, id: \.self) { index in
                RoundedRectangle(cornerRadius: 2)
                    .fill(
                        LinearGradient(
                            colors: [
                                accentBlue.opacity(0.6),
                                accentBlue,
                                Color.white.opacity(0.7)
                            ],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
                    .frame(
                        width: 3,
                        height: barHeight(for: index) + 20
                    )
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
    
    // Microphone Button
    private var microphoneButton: some View {
        ZStack {
            // Outer pulse ring (only when recording)
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
            
            // Outer ring (idle and done states)
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
                    .frame(width: recordingState == .done ? 100 : 120, height: recordingState == .done ? 100 : 120)
            }
            
            // Inner circle
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
                .shadow(color: accentBlue.opacity(0.5), radius: recordingState == .recording ? 20 : 10, x: 0, y: 0)
            
            // Microphone icon
            Image(systemName: "mic.fill")
                .font(.system(size: micIconSize, weight: .medium))
                .foregroundColor(.white)
        }
        .onTapGesture {
            handleMicTap()
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: recordingState)
    }
    
    // Action Area
    @ViewBuilder
    private var actionArea: some View {
        switch recordingState {
        case .idle:
            VStack(spacing: 16) {
                Text("TAP TO RECORD")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white.opacity(0.7))
                    .tracking(1.5)
                
                Button(action: {
                    withAnimation {
                        showAddFilePopup = true
                    }
                }) {
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
            }
            .transition(.opacity)
            
        case .recording:
            // Empty during recording - the button itself is the action
            Color.clear.frame(height: 20)
            
        case .done:
            HStack(spacing: 16) {
                // Re-Record Button
                Button(action: {
                    reRecord()
                }) {
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
                            .overlay(
                                Capsule()
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                    )
                }
                
                // Next Button
                NavigationLink(destination: EmotionPickerView(recordedAudioURL: recordedAudioURL).studioNavbar()) {
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
            }
            .transition(.opacity.combined(with: .move(edge: .bottom)))
        }
    }
    
    // Existing Project Link
    private var existingProjectLink: some View {
        NavigationLink {
            // The view you want to navigate to
            ProjectListView().studioNavbar()
        } label: {
            Text("RECORD TO EXISTING PROJECT?")
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.white.opacity(0.4))
                .tracking(1)
        }
    }
    
    // Computed Properties
    private var formattedTime: String {
        let minutes = elapsedSeconds / 60
        let seconds = elapsedSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
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
    
    private func barHeight(for index: Int) -> CGFloat {
        let amplitude = waveformAmplitudes[index]
        let baseHeight: CGFloat = 8
        let maxAdditional: CGFloat = 72
        return baseHeight + amplitude * maxAdditional
    }
    
    // MARK: - Audio Recording
    
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
    
    // Actions
    private func handleMicTap() {
        withAnimation(.easeInOut(duration: 0.3)) {
            switch recordingState {
            case .idle:
                startRecording()
            case .recording:
                stopRecording()
            case .done:
                startRecording()
            }
        }
    }
    
    private func startRecording() {
        // Request mic permission first
        requestMicrophonePermission()
        
        recordingState = .recording
        elapsedSeconds = 0
        pulseScale = 1.0
        
        // Set up and start real recording
        if let fileURL = setupRecorder() {
            recordedAudioURL = fileURL
            audioRecorder?.record()
        }
        
        // Start pulse animation
        withAnimation(.easeOut(duration: 1.5).repeatForever(autoreverses: false)) {
            pulseScale = 1.6
        }
        
        // Start timer
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            elapsedSeconds += 1
        }
        
        // Animate waveform
        startWaveformAnimation()
    }
    
    private func stopRecording() {
        recordingState = .done
        timer?.invalidate()
        timer = nil
        
        // Stop real recording
        audioRecorder?.stop()
        
        // Freeze waveform
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
            
            // Clean up old recording
            audioRecorder?.stop()
            if let url = recordedAudioURL {
                try? FileManager.default.removeItem(at: url)
            }
            recordedAudioURL = nil
            
            // Reset waveform
            waveformAmplitudes = (0..<40).map { _ in CGFloat.random(in: 0.1...0.6) }
        }
    }
    
    private func startWaveformAnimation() {
        // Simulate live waveform by updating amplitudes
        Timer.scheduledTimer(withTimeInterval: 0.12, repeats: true) { animTimer in
            DispatchQueue.main.async {
                guard recordingState == .recording else {
                    animTimer.invalidate()
                    return
                }
                
                withAnimation(.easeInOut(duration: 0.12)) {
                    for i in 0..<waveformAmplitudes.count {
                        // Create a center-weighted distribution for more natural look
                        let center = CGFloat(waveformAmplitudes.count) / 2
                        let distance = abs(CGFloat(i) - center) / center
                        let maxAmp = 1.0 - (distance * 0.5)
                        waveformAmplitudes[i] = CGFloat.random(in: 0.05...maxAmp)
                    }
                }
            }
        }
    }
}

#Preview {
    RecordingSoundView()
}
