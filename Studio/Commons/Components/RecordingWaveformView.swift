import SwiftUI

struct RecordingWaveformView: View {
    let recordingState: RecordingState
    let waveformAmplitudes: [CGFloat]

    var body: some View {
        HStack(spacing: 3) {
            ForEach(0..<waveformAmplitudes.count, id: \.self) { index in
                RoundedRectangle(cornerRadius: 2)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color("blue-ribbon-700"),
                                Color("blue-ribbon-400"),
                                Color("blue-ribbon-100")
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

    private func barHeight(for index: Int) -> CGFloat {
        let amplitude = waveformAmplitudes[index]
        let baseHeight: CGFloat = 8
        let maxAdditional: CGFloat = 72
        return baseHeight + amplitude * maxAdditional
    }
}
