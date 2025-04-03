//
//  StoryState.swift
//  StoriesDemo
//
//  Created by Adrian Bilescu on 03.04.2025.
//

import Foundation

struct StoryState: Codable {
    let id: Story.ID
    var isSeen: Bool
    var isLiked: Bool
}
