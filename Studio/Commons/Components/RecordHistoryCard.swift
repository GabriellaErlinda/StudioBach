import Models
import Services
import SwiftUI

struct RecordHistoryCard: View {
    let model: RecordHistoryCardModel
    var body: some View {
        HStack(spacing: 16) {
            // Play Button
            Button(
                action: {
                    // Play action
                },
                label: {
                    ZStack {
                        Circle()
                            .fill(Color("blue-ribbon-300").opacity(0.4)) // Lightish grey/purple circle
                            .frame(width: 44, height: 44)
                        // .glassEffect(.clear, in: .circle)
                        Image(systemName: "play.fill")
                            .foregroundColor(Color("blue-ribbon-200"))
                            .font(.title3)
                    }
                }
            )
            .accessibilityIdentifier("recordHistoryPlayButton")
            // Text details
            VStack(alignment: .leading, spacing: 4) {
                Text(model.title)
                    .font(.caption.bold())
                    .foregroundColor(.white)
                Text(model.subtitle)
                    .font(.caption)
                    .foregroundColor(Color("primary-400"))
            }
            Spacer()
            // Download Button
            Button(
                action: {
                    // Download action
                },
                label: {
                    Image(systemName: "square.and.arrow.down")
                        .font(.title3)
                        .foregroundColor(.white)
                }
            )
            .accessibilityIdentifier("recordHistoryDownloadButton")
        }
        .padding()
        .background(Color("blue-ribbon-900").opacity(0.6))
        // .glassEffect(.clear, in: .rect(cornerRadius: 24))
        .cornerRadius(32)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        RecordHistoryCard(model: RecordHistoryCardModel(title: "Vocal Take_04", subtitle: "Today • 14:22 • 0:45s"))
            .padding()
    }
}
