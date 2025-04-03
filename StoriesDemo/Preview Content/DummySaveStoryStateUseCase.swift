//
//  DummySaveStoryStateUseCase.swift
//  StoriesDemo
//
//  Created by Adrian Bilescu on 03.04.2025.
//


import Foundation

struct DummySaveStoryStateUseCase: SaveStoryStateUseCase {
    func saveStoryState(storyId: UUID, state: StoryState) async throws {
        // do nothing
    }
}