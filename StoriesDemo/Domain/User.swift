//
//  User.swift
//  StoriesDemo
//
//  Created by Adrian Bilescu on 03.04.2025.
//

import Foundation

struct User: Identifiable {
    let id: UUID
    let username: String
    let avatarURL: URL
}
