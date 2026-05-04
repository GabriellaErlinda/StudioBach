//
//  ProjectCard.swift
//  Studio
//
//  Created by Gabriella Erlinda on 04/05/26.
//

import SwiftUI

struct ProjectCard: View {
    let project: ProjectCardModel
    
    let themeColor = Color(red: 135/255, green: 153/255, blue: 239/255) // #8799EF
    let cardBackgroundColor = Color(red: 0.08, green: 0.07, blue: 0.13) // Dark purple-black
    
    var body: some View {
        HStack {
            // Sisi Kiri: Teks
            VStack(alignment: .leading, spacing: 4) {
                Text(project.title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                Text(project.subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(themeColor)
            }
            
            Spacer()
            
            // Sisi Kanan: Logika Stack Gambar (Max 3, numpuk)
            RecentSongsStack(recentSongs: project.recentSongs)
            
            Image(systemName: "chevron.right")
                .font(.system(size: 20, weight: .light))
                .foregroundColor(.white)
                .padding(.leading, 8)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 20)
        .background(cardBackgroundColor)
        .cornerRadius(25)
        .overlay(
            RoundedRectangle(cornerRadius: 25)
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
        // Menggunakan Image(systemName:) untuk testing icon.
        // Ubah jadi Image(imageName) nanti jika Anda menggunakan gambar dari Assets.
        Image(systemName: imageName)
            .resizable()
            .scaledToFit()
            .padding(8)
            .frame(width: 40, height: 40)
            .background(Color.gray.opacity(0.3)) // Background agar icon terlihat
            .clipShape(Circle())
            .overlay(
                Circle().stroke(Color.black, lineWidth: 2) // Outline pemisah antar gambar
            )
    }
}

