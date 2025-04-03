//
//  StubFetchStoriesUseCase.swift
//  StoriesDemo
//
//  Created by Adrian Bilescu on 03.04.2025.
//


import Foundation

struct StubFetchStoriesUseCase: FetchStoriesUseCase {
    func fetchStories(userId: User.ID, offset: Int, limit: Int) async throws -> [Story] {
        let stories = (0..<limit).map { index in
            Story(
                id: UUID(),
                userId: userId,
                imageURL: URL(string: "https://i.pravatar.cc/300?u=\(index + 1)")!,
                state: StoryState.initial
            )
        }
        return stories
    }
}
