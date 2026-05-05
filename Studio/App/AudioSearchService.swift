//
//  AudioSearchService.swift
//  Studio
//
//  Networking layer for the StudioBach audio retrieval API.
//

import Foundation
import Combine

// model response API nyax`

struct SearchResponse: Codable {
    let status: String
    let queryTimeSeconds: Double
    let results: [SearchResult]
    
    enum CodingKeys: String, CodingKey {
        case status
        case queryTimeSeconds = "query_time_seconds"
        case results
    }
}

struct SearchResult: Codable, Identifiable {
    var id: String { songId }
    
    let rank: Int
    let songId: String
    let score: Double
    let timestamp: Timestamp
    let moods: [String]
    let trackTitle: String
    let artistName: String
    let albumName: String
    let audioUrl: String
    let albumImageUrl: String
    let artistImageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case rank
        case songId = "song_id"
        case score
        case timestamp
        case moods
        case trackTitle = "track_title"
        case artistName = "artist_name"
        case albumName = "album_name"
        case audioUrl = "audio_url"
        case albumImageUrl = "album_image_url"
        case artistImageUrl = "artist_image_url"
    }
}

struct Timestamp: Codable {
    let start: String
    let end: String
}

// service

class AudioSearchService: ObservableObject {
    static let shared = AudioSearchService()
    
    private let baseURL = "https://api.farrellhrs.dpdns.org"
    
    @Published var searchResults: [SearchResult] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    /// Upload an audio file and get cover song matches.
    func search(audioURL: URL, alpha: Double = 0.5) async throws -> [SearchResult] {
        let endpoint = "\(baseURL)/api/v1/search?alpha=\(alpha)"
        guard let url = URL(string: endpoint) else {
            throw URLError(.badURL)
        }
        
        let boundary = UUID().uuidString
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 120 // API can take ~45s
        
        // Build multipart body
        let audioData = try Data(contentsOf: audioURL)
        var body = Data()
        
        // File field
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"recording.m4a\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: audio/mp4\r\n\r\n".data(using: .utf8)!)
        body.append(audioData)
        body.append("\r\n".data(using: .utf8)!)
        
        // Closing boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard httpResponse.statusCode == 200 else {
            let errorBody = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw NSError(domain: "API", code: httpResponse.statusCode,
                          userInfo: [NSLocalizedDescriptionKey: "Server error \(httpResponse.statusCode): \(errorBody)"])
        }
        
        let decoder = JSONDecoder()
        let searchResponse = try decoder.decode(SearchResponse.self, from: data)
        return searchResponse.results
    }
    
    /// Build a snippet playback URL for a given song and timestamp range.
    func snippetURL(songId: String, start: String, end: String) -> URL? {
        var components = URLComponents(string: "\(baseURL)/api/v1/audio/\(songId)/snippet")
        components?.queryItems = [
            URLQueryItem(name: "start", value: start),
            URLQueryItem(name: "end", value: end)
        ]
        return components?.url
    }
    
    /// Build a full audio URL for a given song.
    func fullAudioURL(songId: String) -> URL? {
        return URL(string: "\(baseURL)/api/v1/audio/\(songId)")
    }
}
