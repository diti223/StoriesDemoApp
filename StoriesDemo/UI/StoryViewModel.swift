//
//  StoryViewModel.swift
//  StoriesDemo
//
//  Created by Adrian Bilescu on 03.04.2025.
//

import Combine
import Foundation

@MainActor
class StoryViewModel: ObservableObject {
    @Published var progress: Double = 0
    private var cancellables = Set<AnyCancellable>()
    private let displayDuration: TimeInterval = 5.0
    private let onTimerComplete: () -> Void
    
    init(onTimerComplete: @escaping () -> Void) {
        self.onTimerComplete = onTimerComplete
    }
    
    func startTimer() {
        progress = 0
        stopTimer()
        
        // Use Combine's timer publisher instead
        Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                self.progress += 0.1 / self.displayDuration
                
                if self.progress >= 1.0 {
                    self.stopTimer()
                    self.onTimerComplete()
                }
            }
            .store(in: &cancellables)
    }
    
    func resumeTimer() {
        // Use Combine's timer publisher instead
        Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                self.progress += 0.1 / self.displayDuration
                
                if self.progress >= 1.0 {
                    self.stopTimer()
                    self.onTimerComplete()
                }
            }
            .store(in: &cancellables)
    }
    
    func pauseTimer() {
        cancellables.removeAll()
    }
    
    func stopTimer() {
        cancellables.removeAll()
    }
}

