//
//  InMemoryUseCaseFactory.swift
//  StoriesDemo
//
//  Created by Adrian Bilescu on 03.04.2025.
//

import Foundation

final class InMemoryUseCaseFactory: UseCaseFactory {
    private let storage = InMemoryStorage()
    
    func makeFetchUsersUseCase() -> FetchUsersUseCase {
        storage
    }
    
    func makeFetchStoriesUseCase() -> FetchStoriesUseCase {
        storage
    }
    
    func makeSaveStoryStateUseCase() -> SaveStoryStateUseCase {
        storage
    }
}

