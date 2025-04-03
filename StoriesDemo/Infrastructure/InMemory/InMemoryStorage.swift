//
//  InMemoryStorage.swift
//  StoriesDemo
//
//  Created by Adrian Bilescu on 03.04.2025.
//

import Foundation

final class InMemoryStorage {
    // MARK: - Properties
    
    private var users: [User] = []
    private var stories: [User.ID: [Story]] = [:]
    
    // MARK: - Initialization
    
    init() {}
    
    func loadData() {
        let users = Self.loadUsersFromJSON()
        self.stories = Self.createDummyStories(users: users)
        self.users = users
    }
}

// MARK: - FetchUsersUseCase Implementation

extension InMemoryStorage: FetchUsersUseCase {
    func fetchUsers() async throws -> [User] {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000)
        return users
    }
}

// MARK: - FetchStoriesUseCase

extension InMemoryStorage: FetchStoriesUseCase {
    func fetchStories(userId: User.ID, offset: Int, limit: Int) async throws -> [Story] {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000)
        
        if let userStories = stories[userId] {
            // Return requested slice of existing stories
            let startIndex = min(offset, userStories.count)
            let endIndex = min(offset + limit, userStories.count)
            
            if startIndex < endIndex {
                return Array(userStories[startIndex..<endIndex])
            }
        }

        throw NoStoriesFoundError()
    }
}

// MARK: - SaveStoryStateUseCase Implementation

extension InMemoryStorage: SaveStoryStateUseCase {
    func saveStoryState(storyId: UUID, state: StoryState) async throws {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 200_000_000)
        
        // Update state in the stories collection
        for (userId, userStories) in stories {
            if let index = userStories.firstIndex(where: { $0.id == storyId }) {
                var updatedStory = userStories[index]
                updatedStory.state = state
                stories[userId]?[index] = updatedStory
                break
            }
        }
    }
}




// MARK: - Load Data
extension InMemoryStorage {
    private static func createDummyStories(users: [User]) -> [User.ID: [Story]] {
        users.reduce(into: [:]) { result, user in
            let storyCount = Int.random(in: 5...10)
            var userStories: [Story] = []
            
            for index in 0..<storyCount {
                let story = createNewStory(id: UUID(), user: user, index: index)
                userStories.append(story)
            }
            
            result[user.id] = userStories
            
        }
    }
    
    private static func loadUsersFromJSON() -> [User] {
        guard let url = Bundle.main.url(forResource: "Users", withExtension: "json") else {
            fatalError("Users.json not found")
        }
        
        do {
            let data = try Data(contentsOf: url)
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            let fileResponse = try jsonDecoder.decode(FileUsersResponse.self, from: data)
            
            return fileResponse.pages.flatMap(\.users).map {
                User(
                    id: $0.id,
                    name: $0.name,
                    profilePictureURL: $0.profilePictureUrl
                )
            }
        } catch {
            fatalError("Failed to load users from JSON: \(error)")
        }
    }
    
    private static func createNewStory(id: Story.ID, user: User, index: Int) -> Story {
        let imageURL = URL(string: "https://picsum.photos/400/600?random=\(index)")!
        
        return Story(
            id: id,
            userId: user.id,
            imageURL: imageURL,
            state: StoryState(
                id: id,
                isSeen: false,
                isLiked: false
            )
        )
    }
}

struct FileUsersResponse: Codable {
    struct Page: Codable {
        let users: [FileUser]
    }
    
    struct FileUser: Codable {
        let id: Int
        let name: String
        let profilePictureUrl: URL
    }
    let pages: [Page]
}
