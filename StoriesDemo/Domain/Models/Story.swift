//
//  Story.swift
//  StoriesDemo
//
//  Created by Adrian Bilescu on 03.04.2025.
//

import Foundation

struct Story: Identifiable {
    let id: UUID
    let userId: User.ID
    let imageURL: URL
    var state: StoryState
}
