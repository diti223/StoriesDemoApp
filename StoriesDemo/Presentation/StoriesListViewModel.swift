//
//  StoriesListViewModel.swift
//  StoriesDemo
//
//  Created by Adrian Bilescu on 03.04.2025.
//
import Combine

@MainActor
class StoriesListViewModel: ObservableObject {
    let storiesFetcher: FetchStoriesUseCase
    let storyStateSaver: SaveStoryStateUseCase
    
    let user: User
    @Published var stories: [Story] = []
    @Published var isLoading = false
    @Published var error: Error?

    private var offset: Int = 0
    private static let storiesFetchLimit: Int = 2

    init(
        user: User,
        storiesFetcher: FetchStoriesUseCase,
        storyStateSaver: SaveStoryStateUseCase
    ) {
        self.user = user
        self.storiesFetcher = storiesFetcher
        self.storyStateSaver = storyStateSaver
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

    func toggleLike(storyId: Story.ID) async {
        guard let index = stories.firstIndex(where: { $0.id == storyId }) else {
            return
        }
        var story = stories[index]
        do {
            var state = story.state
            state.isLiked = !state.isLiked
            try await storyStateSaver.saveStoryState(storyId: storyId, state: state)
            story.state = state
            stories[index] = story
        } catch {
            // silently fail
        }
    }

    func markStoryAsSeen(storyId: Story.ID) async {
        guard let index = stories.firstIndex(where: { $0.id == storyId }) else {
            return
        }
        var story = stories[index]
        do {
            var state = story.state
            state.isSeen = true
            try await storyStateSaver.saveStoryState(storyId: storyId, state: state)
            story.state = state
            stories[index] = story
        } catch {
            // silently fail
        }
    }


    func moveToNextStory() {
        guard !stories.isEmpty else { return }
        
        let currentIndex = currentStoryIndex
        let nextIndex = (currentIndex + 1) % stories.count
        
        // If we're wrapping around and have loaded all stories,
        // fetch more if possible
        if nextIndex == 0 && stories.count >= offset {
            Task {
                await loadMoreStories()
            }
        }
        
        currentStoryIndex = nextIndex
    }
    
    func moveToPreviousStory() {
        guard !stories.isEmpty else { return }
        
        let index = currentStoryIndex
        guard index > 0 else {
            // reset the current index
            currentStoryIndex = 0
            return
        }
        
        currentStoryIndex = index - 1 + stories.count
    }
    
    func loadMoreStories() async {
        isLoading = true
        do {
            let newStories = try await storiesFetcher.fetchStories(
                userId: user.id, 
                offset: offset, 
                limit: Self.storiesFetchLimit
            )
            if !newStories.isEmpty {
                self.stories.append(contentsOf: newStories)
                offset += newStories.count
            }
        } catch {
            self.error = error
        }
        isLoading = false
    }
    
    // Add a property to track current story index
    @Published var currentStoryIndex: Int = 0
    
    var currentStory: Story? {
        guard !stories.isEmpty, currentStoryIndex < stories.count else { return nil }
        return stories[currentStoryIndex]
    }
}   
