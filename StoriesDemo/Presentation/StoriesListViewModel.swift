//
//  StoriesListViewModel.swift
//  StoriesDemo
//
//  Created by Adrian Bilescu on 03.04.2025.
//
import Combine

class StoriesListViewModel: ObservableObject {
    let storiesFetcher: FetchStoriesUseCase
    let user: User
    @Published var stories: [Story] = []
    @Published var isLoading = false
    @Published var error: Error?

    private var offset: Int = 0
    private static let storiesFetchLimit: Int = 2

    init(user: User, storiesFetcher: FetchStoriesUseCase) {
        self.user = user
        self.storiesFetcher = storiesFetcher
    }

    func loadStories() async {
        isLoading = true
        error = nil
        do {
            let stories = try await storiesFetcher.fetchStories(userId: user.id, offset: offset, limit: Self.storiesFetchLimit)
            self.stories = stories
            offset += Self.storiesFetchLimit
        } catch {
            self.error = error
        }
        isLoading = false
    }
}   
