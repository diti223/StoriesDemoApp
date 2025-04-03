//
//  UsersListViewModel.swift
//  StoriesDemo
//
//  Created by Adrian Bilescu on 03.04.2025.
//

import Combine

@MainActor
class UsersListViewModel: ObservableObject {
    let fetcher: FetchUsersUseCase
    
    @Published var selectedUser: User?
    @Published var users: [User] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    init(fetcher: FetchUsersUseCase) {
        self.fetcher = fetcher
    }
    
    func loadInitialUsers() async {
        isLoading = true
        error = nil
        
        await loadUsers()
        
        isLoading = false
    }
    
    func refreshUsers() async {
        await loadUsers()
    }
    
    
    
    private func loadUsers() async {
        do {
            self.users = try await fetcher.fetchUsers()
        } catch {
            self.error = error
        }
        
    }
    
}
