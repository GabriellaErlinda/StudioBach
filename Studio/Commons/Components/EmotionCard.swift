import SwiftUI

struct EmotionModel: Identifiable {
    let id: Int
    let name: String
    let icon: String
    let gradientColors: [Color]

    static let all: [EmotionModel] = [
        EmotionModel(
            id: 0,
            name: "Anger",
            icon: "flame",
            gradientColors: [
                Color("blue-ribbon-400"),
                Color("blue-ribbon-700"),
                Color("blue-ribbon-950"),
            ]
        ),
        EmotionModel(
            id: 1,
            name: "Disgust",
            icon: "hand.raised",
            gradientColors: [
                Color("blue-ribbon-400"),
                Color("blue-ribbon-700"),
                Color("blue-ribbon-950"),
            ]
        ),
        EmotionModel(
            id: 2,
            name: "Fear",
            icon: "eye",
            gradientColors: [
                Color("blue-ribbon-400"),
                Color("blue-ribbon-700"),
                Color("blue-ribbon-950"),
            ]
        ),
        EmotionModel(
            id: 3,
            name: "Happiness",
            icon: "sun.max",
            gradientColors: [
                Color("blue-ribbon-400"),
                Color("blue-ribbon-700"),
                Color("blue-ribbon-950"),
            ]
        ),
        EmotionModel(
            id: 4,
            name: "Sadness",
            icon: "drop",
            gradientColors: [
                Color("blue-ribbon-400"),
                Color("blue-ribbon-700"),
                Color("blue-ribbon-950"),
            ]
        ),
        EmotionModel(
            id: 5,
            name: "Surprise",
            icon: "sparkles",
            gradientColors: [
                Color("blue-ribbon-400"),
                Color("blue-ribbon-700"),
                Color("blue-ribbon-950"),
            ]
        )
    ]
}

struct LargeEmotionCard: View {
    let emotion: EmotionModel
    let isActive: Bool
    var isMarked: Bool = false
    var onToggle: () -> Void = {}

    var body: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.clear)
                .glassEffect(.clear, in: .rect(cornerRadius: 24))
                .background(
                    LinearGradient(
                        colors: emotion.gradientColors.map { $0.opacity(0.8) },
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
            Button(action: onToggle) {
                ZStack {
                    Circle()
                        .fill(isMarked ? Color.blue : Color.white.opacity(0.15))
                        .overlay(
                            Circle().stroke(isMarked ? Color.clear : Color.white.opacity(0.4), lineWidth: 1)
                        )
                    
                    if isMarked {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .frame(width: 24, height: 24)
            }
            .buttonStyle(PlainButtonStyle())
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
