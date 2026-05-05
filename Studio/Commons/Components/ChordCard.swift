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
            .background(Color("blue-ribbon-300"))
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    ChordCard(chord: "Am", chordImage: "chord")
}
