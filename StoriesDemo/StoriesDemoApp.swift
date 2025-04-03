//
//  StoriesDemoApp.swift
//  StoriesDemo
//
//  Created by Adrian Bilescu on 03.04.2025.
//

import SwiftUI

@main
struct StoriesDemoApp: App {
    let inMemoryContainer = InMemoryUseCaseContainer.make()
    
    var body: some Scene {
        WindowGroup {
            UsersListView(
                viewModel: UsersListViewModel(
                    fetcher: inMemoryContainer.fetchUsersUseCase
                )
            )
        }
    }
}

struct InMemoryUseCaseContainer {
    static func make() -> UseCaseContainer {
        let storage = InMemoryStorage()
        storage.loadData()

        return UseCaseContainer(
            fetchUsersUseCase: storage,
            fetchStoriesUseCase: storage,
            saveStoryStateUseCase: storage
        )
    }
}
