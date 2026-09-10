import Models
import Services
import SwiftUI

struct ProjectCard: View {
    let project: ProjectCardModel
    let themeColor = Color(red: 135/255, green: 153/255, blue: 239/255)
    let cardBackgroundColor = Color(red: 0.08, green: 0.07, blue: 0.13)
    var body: some View {
        HStack {
            // Sisi Kiri: Teks
            VStack(alignment: .leading, spacing: 4) {
                Text(project.title)
                    .font(.footnote.bold())
                    .foregroundColor(.white)
                Text(project.subtitle)
                    .font(.callout)
                    .foregroundColor(themeColor)
            }
            Spacer()
            // Sisi Kanan: Logika Stack Gambar (Max 3, numpuk)
            RecentSongsStack(recentSongs: project.recentSongs)
            Image(systemName: "chevron.right")
                .font(.title3)
                .foregroundColor(.white)
                .padding(.leading, 8)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 20)
        .background(cardBackgroundColor)
        .cornerRadius(32)
        .overlay(
            RoundedRectangle(cornerRadius: 32)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}

// --- SUBVIEW PRIVAT UNTUK LOGIKA IMAGE STACK ---
private struct RecentSongsStack: View {
    let recentSongs: [RecentSongModel]
    var body: some View {
        // HStack dengan spacing negatif agar gambar saling tumpang tindih
        HStack(spacing: -12) {
            // Sort berdasarkan tanggal terbaru, lalu batasi hanya 3 (prefix 3)
            ForEach(recentSongs.sorted(by: { $0.dateSaved > $1.dateSaved }).prefix(3)) { song in
                CircularSongImage(imageName: song.imageName)
            }
        }
    }
}

private struct CircularSongImage: View {
    let imageName: String
    var body: some View {
        Image(systemName: imageName)
            .resizable()
            .scaledToFit()
            .padding(8)
            .frame(width: 40, height: 40)
            .background(Color.gray.opacity(0.3))
            .clipShape(Circle())
            .overlay(
                Circle().stroke(Color.black, lineWidth: 2)
            )
    }
}
