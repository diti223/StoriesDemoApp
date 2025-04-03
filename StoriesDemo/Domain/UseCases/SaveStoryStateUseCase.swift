//
//  SaveStoryStateUseCase.swift
//  StoriesDemo
//
//  Created by Adrian Bilescu on 03.04.2025.
//

import Foundation

protocol SaveStoryStateUseCase {
    func saveStoryState(storyId: UUID, state: StoryState) async throws
} 
