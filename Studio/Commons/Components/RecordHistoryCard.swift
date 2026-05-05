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
                        .fill(Color("blue-ribbon-300").opacity(0.4)) // Lightish grey/purple circle
                        .frame(width: 44, height: 44)
                        //.glassEffect(.clear, in: .circle)
                    Image(systemName: "play.fill")
                        .foregroundColor(Color("blue-ribbon-200"))
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
                    .foregroundColor(Color("primary-400"))
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
        .background(Color("blue-ribbon-900").opacity(0.6))
        //.glassEffect(.clear, in: .rect(cornerRadius: 24))
        .cornerRadius(32)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        RecordHistoryCard(model: RecordHistoryCardModel(title: "Vocal Take_04 (Harmony Focus)", subtitle: "Today • 14:22 • 0:45s"))
            .padding()
    }
}
