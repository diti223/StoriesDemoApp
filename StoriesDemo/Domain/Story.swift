//
//  Story.swift
//  StoriesDemo
//
//  Created by Adrian Bilescu on 03.04.2025.
//

import Foundation

struct Story: Identifiable {
    let id: UUID
    let user: User
    let imageURL: URL
    var isSeen: Bool
    var isLiked: Bool
}
