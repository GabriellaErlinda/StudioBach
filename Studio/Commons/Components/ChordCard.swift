import SwiftUI

struct ChordCard: View {
    
    let chord: String
    let chordImage: String
    
    var body: some View {
        
        VStack(spacing: 5) {
            Text(chord)
            Image(chordImage)
        }
            .padding()
            .frame(width: 75, height: 75)
            .foregroundStyle(.white)
            .fontWeight(.bold)
            .glassEffect(.clear)
            .background(Color(red: 0.3333333333333333, green: 0.3764705882352941, blue: 0.9686274509803922, opacity: 0.5))
            .clipShape(RoundedRectangle(cornerRadius: 48))
    }
}

#Preview {
    ChordCard(chord: "Am", chordImage: "chord")
}
