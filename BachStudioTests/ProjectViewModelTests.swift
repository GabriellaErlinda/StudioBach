@testable import BachStudio
import Foundation
import Models
import Services
import Testing

@MainActor
@Suite("ProjectViewModel")
struct ProjectViewModelTests {
    @Test("starts with the 3 seeded dummy projects, most recent first")
    func seededProjects() {
        let vm = ProjectViewModel()
        #expect(vm.projects.count == 3)
        #expect(vm.projects.map(\.title) == ["PROJECT 3", "PROJECT 2", "PROJECT 1"])
    }

    @Test("saveSongToNewProject inserts the new project at the front of the list")
    func insertsAtFront() {
        let vm = ProjectViewModel()
        let countBefore = vm.projects.count
        vm.saveSongToNewProject(title: "My New Song", coverImage: "cover.png", recordedAudio: nil)
        #expect(vm.projects.count == countBefore + 1)
        #expect(vm.projects.first?.title == "My New Song")
    }

    @Test("the new project contains exactly one song built from the given cover image")
    func newProjectHasOneSong() throws {
        let vm = ProjectViewModel()
        vm.saveSongToNewProject(title: "Solo Take", coverImage: "waveform.png", recordedAudio: nil)
        let newProject = try #require(vm.projects.first)
        #expect(newProject.recentSongs.count == 1)
        #expect(newProject.recentSongs.first?.imageName == "waveform.png")
    }

    @Test("detected emotion on save is deterministic via injection")
    func testAnalyzeEmotionIsDeterministic() throws {
        let vm = ProjectViewModel()
        vm.randomEmotionProvider = { _ in return .joyful }
        vm.saveSongToNewProject(title: "Emotion Check", coverImage: "cover.png", recordedAudio: nil)
        let savedProject = try #require(vm.projects.first)
        let savedSong = try #require(savedProject.recentSongs.first)
        #expect(savedSong.emotion == .joyful)
    }

    @Test("saveSongToNewProject uses injected date")
    func testSaveSongToNewProjectUsesInjectedDate() throws {
        let vm = ProjectViewModel()
        let mockDate = Date(timeIntervalSince1970: 1672531200) // 2023-01-01
        vm.currentDateProvider = { return mockDate }
        vm.saveSongToNewProject(title: "Timing Check", coverImage: "cover", recordedAudio: nil)
        let savedProject = try #require(vm.projects.first)
        let savedSong = try #require(savedProject.recentSongs.first)
        #expect(savedSong.dateSaved == mockDate)
    }

    @Test("subtitle of a freshly saved project matches its single song's emotion")
    func subtitleReflectsNewSong() throws {
        let vm = ProjectViewModel()
        vm.randomEmotionProvider = { _ in return .calm }
        vm.saveSongToNewProject(title: "Subtitle Check", coverImage: "cover", recordedAudio: nil)
        let project = try #require(vm.projects.first)
        #expect(project.subtitle == SongEmotion.calm.rawValue)
    }

    @Test("repeated saves keep prior projects intact, just pushed down")
    func doesNotClobberExistingProjects() throws {
        let vm = ProjectViewModel()
        let titlesBefore = vm.projects.map(\.title)
        vm.saveSongToNewProject(title: "Newest", coverImage: "cover", recordedAudio: nil)
        #expect(Array(vm.projects.dropFirst().map(\.title)) == titlesBefore)
    }
}
