//
//  PreviewFetchUsersUseCase.swift
//  StoriesDemo
//
//  Created by Adrian Bilescu on 03.04.2025.
//

import Foundation

struct StubFetchUsersUseCase: FetchUsersUseCase {
    let result: Result<[User], Error>
    func fetchUsers() async throws -> [User] {
        switch result {
            case .success(let users):
                return users
            case .failure(let error):
                throw error
        }
    }
    
    static func makeSuccess(count: Int = 1) -> StubFetchUsersUseCase {
        let users = (0..<count).map { index in
            User(id: Int.random(in: 0..<100), name: "John Doe", profilePictureURL: URL(string: "https://i.pravatar.cc/300?u=\(index + 1)")!)
        }
        return StubFetchUsersUseCase(result: .success(users))
    }
    
    static func makeFailure(error: Error) -> StubFetchUsersUseCase {
        return StubFetchUsersUseCase(result: .failure(error))
    }
}
