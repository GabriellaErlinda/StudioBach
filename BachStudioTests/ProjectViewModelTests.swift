@testable import BachStudio
import Foundation
import Models
import Services
import Testing

@MainActor
@Suite("ProjectViewModel")
struct ProjectViewModelTests {

    // Fragile by design: this locks in the current hardcoded dummy seed data.
    // It WILL break the moment that seed data changes or is replaced by real
    // persistence — that's expected. Delete/update this test at that point;
    // it's here only because the seeded state is real, observable behavior today.
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

    @Test("detected emotion on save always falls within the analyzer's known output set")
    func emotionIsWithinKnownSet() throws {
        let vm = ProjectViewModel()
        let allowedEmotions: Set<SongEmotion> = [.joyful, .sadness, .nostalgic, .energetic, .calm]

        // analyzeEmotion is randomized (randomElement() over a non-empty array, so it can
        // never actually produce .unknown despite the fallback). Run enough iterations to
        // make a silent regression (e.g. someone adding a case to the source array without
        // updating this set) likely to surface, without asserting exact distribution.
        for i in 0..<20 {
            vm.saveSongToNewProject(title: "Take \(i)", coverImage: "cover", recordedAudio: nil)
            let emotion = try #require(vm.projects.first?.recentSongs.first?.emotion)
            #expect(allowedEmotions.contains(emotion))
        }
    }

    @Test("saved song's dateSaved is set at call time")
    func dateSavedIsRecent() throws {
        let vm = ProjectViewModel()
        let before = Date()
        vm.saveSongToNewProject(title: "Timing Check", coverImage: "cover", recordedAudio: nil)
        let after = Date()

        let saved = try #require(vm.projects.first?.recentSongs.first?.dateSaved)
        #expect(saved >= before)
        #expect(saved <= after)
    }

    @Test("subtitle of a freshly saved project matches its single song's emotion")
    func subtitleReflectsNewSong() throws {
        let vm = ProjectViewModel()
        vm.saveSongToNewProject(title: "Subtitle Check", coverImage: "cover", recordedAudio: nil)

        let project = try #require(vm.projects.first)
        let emotion = try #require(project.recentSongs.first?.emotion)
        #expect(project.subtitle == emotion.rawValue)
    }

    @Test("repeated saves keep prior projects intact, just pushed down")
    func doesNotClobberExistingProjects() throws {
        let vm = ProjectViewModel()
        let titlesBefore = vm.projects.map(\.title)

        vm.saveSongToNewProject(title: "Newest", coverImage: "cover", recordedAudio: nil)

        #expect(Array(vm.projects.dropFirst().map(\.title)) == titlesBefore)
    }
}
