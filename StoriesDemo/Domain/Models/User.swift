//
//  User.swift
//  StoriesDemo
//
//  Created by Adrian Bilescu on 03.04.2025.
//

import Foundation

struct User: Codable, Identifiable {
    let id: Int
    let name: String
    let profilePictureURL: URL
}
