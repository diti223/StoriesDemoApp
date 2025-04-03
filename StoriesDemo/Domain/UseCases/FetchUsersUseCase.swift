//
//  FetchUsersUseCase.swift
//  StoriesDemo
//
//  Created by Adrian Bilescu on 03.04.2025.
//

import Foundation

protocol FetchUsersUseCase {
    func fetchUsers() async throws -> [User]
}