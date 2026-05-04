import SwiftUI

struct EmotionModel: Identifiable {
    let id: Int
    let name: String
    let icon: String
    let gradientColors: [Color]

    static let all: [EmotionModel] = [
        EmotionModel(
            id: 0,
            name: "Joyful",
            icon: "bolt",
            gradientColors: [
                Color(red: 0.38, green: 0.32, blue: 0.78),
                Color(red: 0.20, green: 0.16, blue: 0.56),
                Color(red: 0.36, green: 0.09, blue: 0.40),
            ]
        ),
        EmotionModel(
            id: 1,
            name: "Sadness",
            icon: "drop",
            gradientColors: [
                Color(red: 0.38, green: 0.32, blue: 0.78),
                Color(red: 0.20, green: 0.16, blue: 0.56),
                Color(red: 0.36, green: 0.09, blue: 0.40),
            ]
        ),
        EmotionModel(
            id: 2,
            name: "Nostalgia",
            icon: "opticaldisc",
            gradientColors: [
                Color(red: 0.38, green: 0.32, blue: 0.78),
                Color(red: 0.20, green: 0.16, blue: 0.56),
                Color(red: 0.36, green: 0.09, blue: 0.40),
            ]
        ),
    ]
}

struct LargeEmotionCard: View {
    let emotion: EmotionModel
    let isActive: Bool

    var body: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.clear)
                .glassEffect(.clear, in: .rect(cornerRadius: 24))
                .background(
                    LinearGradient(
                        colors: emotion.gradientColors.map { $0.opacity(0.8) }, // Match the subtle transparency of other features
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                )

            // Subtle inner highlight at top-left
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        colors: [Color.white.opacity(0.12), Color.clear],
                        startPoint: .topLeading,
                        endPoint: .center
                    )
                )

            // Card content
            VStack(spacing: 0) {
                Spacer()

                Text(emotion.name)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.white)

                Spacer().frame(height: 18)

                Image(systemName: emotion.icon)
                    .font(.system(size: 64, weight: .regular))
                    .foregroundStyle(.white)
                    .shadow(color: .white.opacity(0.3), radius: 10, x: 0, y: 4)

                Spacer()
            }
            .frame(maxWidth: .infinity)

            // Selection dot indicator — top right
            Circle()
                .fill(Color.white.opacity(0.80))
                .frame(width: 24, height: 24)
                .padding(18)
        }
        .frame(width: isActive ? 342 : 237, height: isActive ? 172 : 106)
    }
}

#Preview {
    LargeEmotionCard(emotion: EmotionModel.all[1], isActive: true)
        .padding()
        .background(Color.black)
}
