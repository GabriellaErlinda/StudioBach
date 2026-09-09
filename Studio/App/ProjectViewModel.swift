import Combine
import Foundation
import Models
import Services
import SwiftUI

class ProjectViewModel: ObservableObject {
    @Published var projects: [ProjectCardModel] = [
        ProjectCardModel(
            title: "PROJECT 3",
            recentSongs: [
                RecentSongModel(imageName: "guitar", dateSaved: Date().addingTimeInterval(-10), emotion: .sadness),
                RecentSongModel(imageName: "keyboard", dateSaved: Date().addingTimeInterval(-20), emotion: .joyful),
                RecentSongModel(imageName: "waveform", dateSaved: Date().addingTimeInterval(-30), emotion: .nostalgic)
            ]
        ),
        ProjectCardModel(
            title: "PROJECT 2",
            recentSongs: [
                RecentSongModel(imageName: "mic.fill", dateSaved: Date().addingTimeInterval(-5), emotion: .joyful),
                RecentSongModel(imageName: "speaker.wave.2.fill", dateSaved: Date().addingTimeInterval(-15), emotion: .energetic)
            ]
        ),
        ProjectCardModel(
            title: "PROJECT 1",
            recentSongs: [
                RecentSongModel(imageName: "play.fill", dateSaved: Date().addingTimeInterval(-50), emotion: .nostalgic)
            ]
        )
    ]

    private let audioSearchService: AudioSearchServiceProtocol

    // Dependency Injection Seam
    init(audioSearchService: AudioSearchServiceProtocol = AudioSearchService()) {
        self.audioSearchService = audioSearchService
    }

    private func analyzeEmotion(from audioRecord: Any?) -> SongEmotion {
        let detectedEmotions: [SongEmotion] = [.joyful, .sadness, .nostalgic, .energetic, .calm]
        return detectedEmotions.randomElement() ?? .unknown
    }

    func saveSongToNewProject(title: String, coverImage: String, recordedAudio: Any?) {
        let detectedEmotion = analyzeEmotion(from: recordedAudio)
        let newSong = RecentSongModel(
            imageName: coverImage,
            dateSaved: Date(),
            emotion: detectedEmotion
        )
        let newProject = ProjectCardModel(
            title: title,
            recentSongs: [newSong]
        )
        projects.insert(newProject, at: 0)
    }
}
