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
        self.users = Self.loadUsersFromJSON()
        loadDummyStories()
    }
    
    // MARK: - Private Methods
    
    private func loadDummyStories() {
        // Generate 5-10 random stories for each user
        for user in users {
            let storyCount = Int.random(in: 5...10)
            var userStories: [Story] = []
            
            for index in 0..<storyCount {
                let story = createNewStory(id: UUID(), user: user, index: index)
                userStories.append(story)
            }
            
            stories[user.id] = userStories
        }
    }
    
    private static func loadUsersFromJSON() -> [User] {
        guard let url = Bundle.main.url(forResource: "Users", withExtension: "json") else {
            fatalError("Users.json not found")
        }
        
        do {
            let data = try Data(contentsOf: url)
            let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            
            guard let pages = jsonObject?["pages"] as? [[String: Any]] else {
                fatalError("Invalid JSON structure: missing pages")
            }
            
            var users: [User] = []
            
            for page in pages {
                guard let usersArray = page["users"] as? [[String: Any]] else {
                    continue
                }
                
                for userData in usersArray {
                    guard 
                        let id = userData["id"] as? Int,
                        let name = userData["name"] as? String,
                        let profilePictureURL = userData["profile_picture_url"] as? String,
                        let url = URL(string: profilePictureURL)
                    else {
                        continue
                    }
                    
                    let user = User(
                        id: UUID(integer: id),
                        name: name,
                        profilePictureURL: url
                    )
                    users.append(user)
                }
            }
            
            return users
        } catch {
            fatalError("Failed to load users from JSON: \(error)")
        }
    }
    
    private func createNewStory(id: Story.ID, user: User, index: Int) -> Story {
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

// MARK: - FetchUsersUseCase Implementation

extension InMemoryStorage: FetchUsersUseCase {
    func fetchUsers() async throws -> [User] {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000)
        return users
    }
}

// MARK: - FetchStoriesUseCase Implementation

extension InMemoryStorage: FetchStoriesUseCase {
    func fetchStories(userId: UUID, offset: Int, limit: Int) async throws -> [Story] {
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

        throw NoStoriesError()
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

// MARK: - UUID Extension

extension UUID {
    init(integer: Int) {
        self.init(uuidString: "00000000-0000-0000-0000-\(String(format: "%012d", integer))")!
    }
} 

struct NoStoriesError: Error {}
