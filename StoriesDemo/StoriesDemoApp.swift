//
//  StoriesDemoApp.swift
//  StoriesDemo
//
//  Created by Adrian Bilescu on 03.04.2025.
//

import SwiftUI

@main
struct StoriesDemoApp: App {
    let inMemoryStorage = InMemoryStorage()
    
    var body: some Scene {
        WindowGroup {
            UsersListView(
                storyView: { user in
                    StoriesView(
                        viewModel: StoriesListViewModel(
                            user: user,
                            storiesFetcher: inMemoryStorage,
                            storyStateSaver: inMemoryStorage
                        )
                    )
                },
                viewModel: UsersListViewModel(
                    fetcher: inMemoryStorage
                )
            )
        }
    }
}
