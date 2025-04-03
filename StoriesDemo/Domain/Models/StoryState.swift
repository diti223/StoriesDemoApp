//
//  StoryState.swift
//  StoriesDemo
//
//  Created by Adrian Bilescu on 03.04.2025.
//

import Foundation

struct StoryState: Codable {
    let storyId: UUID
    let isSeen: Bool
    let isLiked: Bool
}
