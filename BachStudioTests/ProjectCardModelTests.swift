@testable import BachStudio
import Foundation
import Models
import Services
import Testing

@MainActor
@Suite("ProjectCardModel")
struct ProjectCardModelTests {

    @Test("subtitle returns 'Empty Project' when there are no songs")
    func emptyProjectSubtitle() {
        let project = ProjectCardModel(title: "Test Project", recentSongs: [])
        #expect(project.subtitle == "Empty Project")
    }

    @Test("subtitle returns the emotion of the single song when there's only one")
    func singleSongSubtitle() {
        let song = RecentSongModel(imageName: "mic", dateSaved: Date(), emotion: .joyful)
        let project = ProjectCardModel(title: "Test Project", recentSongs: [song])
        #expect(project.subtitle == SongEmotion.joyful.rawValue)
    }

    @Test("subtitle picks the most recently *saved* song, not the last one in the array")
    func picksLatestByDateNotArrayOrder() {
        let older = RecentSongModel(imageName: "a", dateSaved: Date().addingTimeInterval(-100), emotion: .sadness)
        let newer = RecentSongModel(imageName: "b", dateSaved: Date(), emotion: .energetic)

        let projectA = ProjectCardModel(title: "A", recentSongs: [newer, older])
        #expect(projectA.subtitle == SongEmotion.energetic.rawValue)

        let projectB = ProjectCardModel(title: "B", recentSongs: [older, newer])
        #expect(projectB.subtitle == SongEmotion.energetic.rawValue)
    }

    @Test("subtitle does not crash when two songs share the exact same timestamp")
    func tiedDatesDoesNotCrash() {
        let now = Date()
        let songA = RecentSongModel(imageName: "a", dateSaved: now, emotion: .calm)
        let songB = RecentSongModel(imageName: "b", dateSaved: now, emotion: .nostalgic)
        let project = ProjectCardModel(title: "Tie", recentSongs: [songA, songB])

        let subtitle = project.subtitle
        #expect(subtitle == SongEmotion.calm.rawValue || subtitle == SongEmotion.nostalgic.rawValue)
    }

    @Test("each ProjectCardModel instance gets a unique id")
    func uniqueIDs() {
        let a = ProjectCardModel(title: "A")
        let b = ProjectCardModel(title: "B")
        #expect(a.id != b.id)
    }
}

@MainActor
@Suite("SongEmotion")
struct SongEmotionTests {

    @Test(
        "raw value matches the expected display string",
        arguments: [
            (SongEmotion.joyful, "Joyful"),
            (SongEmotion.sadness, "Sadness"),
            (SongEmotion.nostalgic, "Nostalgic"),
            (SongEmotion.energetic, "Energetic"),
            (SongEmotion.calm, "Calm"),
            (SongEmotion.unknown, "Unknown")
        ]
    )
    func rawValues(emotion: SongEmotion, expected: String) {
        #expect(emotion.rawValue == expected)
    }
}

@MainActor
@Suite("RecordHistoryCardModel")
struct RecordHistoryCardModelTests {

    @Test("stores title and subtitle as given, with a unique id per instance")
    func storesFieldsVerbatim() {
        let a = RecordHistoryCardModel(title: "Take 1", subtitle: "Today")
        let b = RecordHistoryCardModel(title: "Take 1", subtitle: "Today")

        #expect(a.title == "Take 1")
        #expect(a.subtitle == "Today")
        #expect(a.id != b.id)
    }
}
