//
//  ProjectCardModel.swift
//  Studio
//
//  Created by Gabriella Erlinda on 04/05/26.
//

import Foundation

// 1. Buat Enum untuk daftar emosi agar rapi dan seragam (Bisa disesuaikan nanti)
enum SongEmotion: String {
    case joyful = "Joyful"
    case sadness = "Sadness"
    case nostalgic = "Nostalgic"
    case energetic = "Energetic"
    case calm = "Calm"
    case unknown = "Unknown"
}

struct RecentSongModel: Identifiable {
    let id = UUID()
    let imageName: String
    let dateSaved: Date
    let emotion: SongEmotion // <-- Tambahkan properti emosi di tiap lagu
}

struct ProjectCardModel: Identifiable {
    let id = UUID()
    var title: String
    var recentSongs: [RecentSongModel] = []
    
    // 2. LOGIC UTAMA: Subtitle otomatis, bukan lagi String manual
    var subtitle: String {
        // Cari lagu dengan tanggal paling baru
        if let latestSong = recentSongs.sorted(by: { $0.dateSaved > $1.dateSaved }).first {
            // Kembalikan nama emosi dari lagu terbaru tersebut
            return latestSong.emotion.rawValue
        } else {
            // Jika project belum punya lagu sama sekali
            return "Empty Project"
        }
    }
}
