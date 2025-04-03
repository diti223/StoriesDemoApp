//
//  PreviewFetchUsersUseCase.swift
//  StoriesDemo
//
//  Created by Adrian Bilescu on 03.04.2025.
//

import Foundation

struct PreviewFetchUsersUseCase: FetchUsersUseCase {
    func fetchUsers() async throws -> [User] {
        return [
            User(id: UUID(), name: "John Doe", profilePictureURL: URL(string: "https://i.pravatar.cc/300?u=1")!)
        ]
    }
}
