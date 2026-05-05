//
//  InfoPopUpView.swift
//  BachStudio
//
//  Created by Gabriella Erlinda on 06/05/26.
//

import SwiftUI

struct InfoPopUpView: View {

    private let profileURL = URL(string: "https://www.figma.com/api/mcp/asset/61fd2b9c-1684-4566-95dc-df36c2626b26")

    var body: some View {
        VStack(spacing: 16) {
            profileAvatar
            headerText
            featureList
            ctaButton
        }
        .padding(16)
        .background(glassCard)
        .clipShape(cardShape)
        .overlay(cardShape.strokeBorder(Color.white.opacity(0.12), lineWidth: 0.5))
        .shadow(color: .white.opacity(0.04), radius: 10, x: 4, y: 4)
    }

    // MARK: - Subviews

    private var profileAvatar: some View {
        AsyncImage(url: profileURL) { image in
            image.resizable().scaledToFill()
        } placeholder: {
            Circle().fill(Color.gray.opacity(0.3))
        }
        .frame(width: 64, height: 64)
        .clipShape(Circle())
    }

    private var headerText: some View {
        VStack(spacing: 8) {
            Text("Get in Composing")
                .font(.custom("Urbanist-Bold", size: 20))
                .tracking(-0.15)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .center)

            Text("All you need for fast accurate chords and melody")
                .font(.custom("Urbanist-Regular", size: 11))
                .tracking(-0.16)
                .foregroundColor(.white.opacity(0.5))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
        }
    }

    private var featureList: some View {
        VStack(alignment: .leading, spacing: 8) {
            FeatureRow(icon: "waveform", label: "Record your melody")
            FeatureRow(
                icon: "music.note",
                label: "Get your suggested music\nbased on your melody",
                labelWidth: 90
            )
        }
    }

    private var ctaButton: some View {
        Text("Get Started")
            .font(.custom("Urbanist-Bold", size: 12))
            .foregroundColor(Color(hex: "bfbfbf"))
            .padding(.horizontal, 24)
            .padding(.vertical, 8)
            .background(
                LinearGradient(
                    colors: [Color(hex: "5560f7"), Color(hex: "323891")],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(Capsule())
    }

    // Top-right corner is sharp; all others are 24pt
    private var cardShape: UnevenRoundedRectangle {
        UnevenRoundedRectangle(
            topLeadingRadius: 24,
            bottomLeadingRadius: 24,
            bottomTrailingRadius: 24,
            topTrailingRadius: 0
        )
    }

    // Frosted glass card: blur backdrop + semi-transparent gradient tint
    private var glassCard: some View {
        ZStack {
            // Backdrop blur — recreates CSS backdrop-filter: blur()
            Color.clear
                .background(.ultraThinMaterial)

            // Gradient tint on top of the blur
            LinearGradient(
                stops: [
                    .init(color: Color(red: 91/255, green: 96/255, blue: 242/255).opacity(0.18), location: 0),
                    .init(color: Color(red: 6/255, green: 7/255, blue: 22/255).opacity(0.18), location: 1)
                ],
                startPoint: UnitPoint(x: 0.179, y: 0.117),
                endPoint: UnitPoint(x: 0.821, y: 0.883)
            )
        }
    }
}

// MARK: - Feature Row
private struct FeatureRow: View {
    let icon: String
    let label: String
    var labelWidth: CGFloat? = nil

    var body: some View {
        HStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(red: 13/255, green: 0, blue: 80/255))
                    .blendMode(.screen)
                Image(systemName: icon)
                    .font(.system(size: 7, weight: .regular))
                    .foregroundColor(Color(red: 181/255, green: 198/255, blue: 255/255))
            }
            .frame(width: 20, height: 20)
            .drawingGroup()

            Text(label)
                .font(.custom("Urbanist-Bold", size: 8))
                .tracking(-0.16)
                .foregroundColor(.white)
                .lineSpacing(1)
                .frame(width: labelWidth, alignment: .leading)
        }
    }
}

// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

// MARK: - Preview
#Preview {
    InfoPopUpView()
        .frame(width: 200)
        .background(Color(red: 6/255, green: 7/255, blue: 22/255))
        .padding(32)
}
