import SwiftUI

struct RecordHistoryCard: View {
    let model: RecordHistoryCardModel
    
    var body: some View {
        HStack(spacing: 16) {
            // Play Button
            Button(action: {
                // Play action
            }) {
                ZStack {
                    Circle()
                        .fill(Color(red: 0.23, green: 0.23, blue: 0.32)) // Lightish grey/purple circle
                        .frame(width: 44, height: 44)
                        //.glassEffect(.clear, in: .circle)
                    Image(systemName: "play.fill")
                        .foregroundColor(Color(red: 0.55, green: 0.55, blue: 0.65))
                        .font(.system(size: 20))
                        
                }
            }
            
            // Text details
            VStack(alignment: .leading, spacing: 4) {
                Text(model.title)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
                
                Text(model.subtitle)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.7))
            }
            
            Spacer()
            
            // Download Button
            Button(action: {
                // Download action
            }) {
                Image(systemName: "square.and.arrow.down")
                    .font(.system(size: 20, weight: .regular))
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(Color(red: 0.12, green: 0.09, blue: 0.18)) // Dark purple background from image
        .glassEffect(.clear, in: .rect(cornerRadius: 24))
        .cornerRadius(24)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        RecordHistoryCard(model: RecordHistoryCardModel(title: "Vocal Take_04 (Harmony Focus)", subtitle: "Today • 14:22 • 0:45s"))
            .padding()
    }
}
