//
//  StoryView.swift
//  StoriesDemo
//
//  Created by Adrian Bilescu on 03.04.2025.
//

import SwiftUI

struct StoryView: View {
    let story: Story
    let onLikeToggle: (Bool) -> Void
    let onNext: () -> Void
    let onPrevious: () -> Void
    
    @StateObject private var viewModel: StoryViewModel
    
    init(story: Story, onLikeToggle: @escaping (Bool) -> Void, onNext: @escaping () -> Void, onPrevious: @escaping () -> Void) {
        self.story = story
        self.onLikeToggle = onLikeToggle
        self.onNext = onNext
        self.onPrevious = onPrevious
        _viewModel = StateObject(wrappedValue: StoryViewModel(onTimerComplete: onNext))
    }
    
    var body: some View {
        VStack {
            makeProgressBar()
            makeStoryContent()
        }
        .padding(.horizontal)
        .onAppear {
            viewModel.startTimer()
        }
        .onDisappear {
            viewModel.stopTimer()
        }
    }
    
    @ViewBuilder
    private func makeProgressBar() -> some View {
        GeometryReader { geometry in
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.white.opacity(0.3))
                .frame(width: geometry.size.width, height: 4)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white)
                        .animation(.smooth, value: viewModel.progress)
                        .frame(width: geometry.size.width * viewModel.progress, height: 4),
                    alignment: .leading
                )
        }
        .frame(height: 4)
        .padding([.horizontal, .top])
    }
    
    @ViewBuilder
    private func makeStoryContent() -> some View {
        ZStack(alignment: .bottom) {
            makeStoryImage()
            makeLikeButton()
        }
    }
    
    @ViewBuilder
    private func makeStoryImage() -> some View {
        AsyncImage(url: story.imageURL) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay {
            HStack {
                Color.white.opacity(0.01)
                    .onTapGesture(count: 1) { location in
                        onPrevious()
                    }
                Color.white.opacity(0.01)
                    .onTapGesture(count: 1) { location in
                        onNext()
                    }
            }
            
        }
//        .onTapGesture(count: 1) { location in
//            // Left side of screen goes to previous, right side to next
//            if location.x < UIScreen.main.bounds.width / 2 {
//                onPrevious()
//            } else {
//                onNext()
//            }
//        }
        .onLongPressGesture(minimumDuration: 0.05, pressing: { isPressing in
            // Pause timer when user is pressing
            if isPressing {
                viewModel.stopTimer()
            } else {
                viewModel.resumeTimer()
            }
        }, perform: {})
    }
    
    @ViewBuilder
    private func makeLikeButton() -> some View {
        Button(action: {
            onLikeToggle(!story.state.isLiked)
        }) {
            Image(systemName: story.state.isLiked ? "heart.fill" : "heart")
                .font(.title)
                .foregroundStyle(story.state.isLiked ? .red : .white)
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(Circle())
        }
        .padding([.bottom, .trailing], 16)
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}
