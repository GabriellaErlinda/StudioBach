//
//  EmotionDetailCard.swift
//  Minty
//
//  Created by Nickson Leviel on 04/05/26.
//

import SwiftUI

struct EmotionDetailCard: View {
    
    let emotion: String
    let iconName: String
    
    var body: some View {
        
        HStack {
            Image(systemName: iconName)
            Text(emotion)
        }
        .padding()
        .foregroundStyle(.white)
        .fontWeight(.bold)
        .glassEffect(.clear)
        .background(Color(red: 0.3333333333333333, green: 0.3764705882352941, blue: 0.9686274509803922, opacity: 0.5)).clipShape(RoundedRectangle(cornerRadius: 48))
    }
}

#Preview {
    EmotionDetailCard(emotion: "Happy", iconName: "face.smiling")
}
