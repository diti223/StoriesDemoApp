//
//  FetchStoriesUseCase.swift
//  StoriesDemo
//
//  Created by Adrian Bilescu on 03.04.2025.
//

import Foundation

protocol FetchStoriesUseCase {
    func fetchStories(userId: UUID, offset: Int, limit: Int) async throws -> [Story]
}
