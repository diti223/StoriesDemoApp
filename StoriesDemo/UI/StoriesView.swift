//
//  StoriesView.swift
//  StoriesDemo
//
//  Created by Adrian Bilescu on 03.04.2025.
//

import SwiftUI
import Combine

struct StoriesView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: StoriesListViewModel
    var user: User {
        viewModel.user
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea()
            VStack {
                makeHeaderView()
                Spacer()
                makeMainContentView()
                Spacer()
            }
        }
        .foregroundStyle(.white)
    }
    
    @ViewBuilder
    private func makeHeaderView() -> some View {
        HStack {
            Spacer()
            Button(
                action: {
                    dismiss()
                },
                label: {
                    Label("", systemImage: "xmark")
                        .font(.headline)
                        .bold()
                }
            )
            .padding()
        }
    }
    
    @ViewBuilder
    private func makeMainContentView() -> some View {
        if viewModel.isLoading && viewModel.stories.isEmpty {
            makeLoadingView()
        } else if let error = viewModel.error {
            makeErrorView(error: error)
        } else if viewModel.stories.isEmpty {
            makeEmptyStateView()
        } else {
            makeStoriesCarouselView()
        }
    }
    
    @ViewBuilder
    private func makeLoadingView() -> some View {
        ProgressView()
            .tint(.white)
    }
    
    @ViewBuilder
    private func makeErrorView(error: Error) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
            
            Text("Unable to load stories")
                .font(.headline)
            
            Text(error.localizedDescription)
                .font(.caption)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Try Again") {
                Task {
                    await viewModel.loadStories()
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(.white.opacity(0.3))
        }
    }
    
    @ViewBuilder
    private func makeEmptyStateView() -> some View {
        VStack {
            Image(systemName: "photo.on.rectangle.angled")
                .font(.largeTitle)
            Text("No stories available")
                .font(.headline)
        }
        .onAppear {
            Task {
                await viewModel.loadStories()
            }
        }
    }
    
    @ViewBuilder
    private func makeStoriesCarouselView() -> some View {
        VStack {
            TabView(selection: $viewModel.currentStoryIndex) {
                ForEach(Array(viewModel.stories.enumerated()), id: \.element.id) { index, story in
                    StoryView(
                        story: story,
                        onLikeToggle: {
                            Task {
                                await viewModel.toggleLike(storyId: story.id)
                            }
                        },
                        onNext: {
                            viewModel.moveToNextStory()
                        },
                        onPrevious: {
                            viewModel.moveToPreviousStory()
                        }
                    )
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onChange(of: viewModel.currentStoryIndex) { _, newIndex in
                if let story = viewModel.stories[safe: newIndex] {
                    Task {
                        await viewModel.markStoryAsSeen(storyId: story.id)
                    }
                }
            }
            .onAppear {
                Task {
                    await viewModel.loadStories()
                }
            }
        }
    }
}
