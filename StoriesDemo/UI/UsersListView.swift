//
//  UsersListView.swift
//  StoriesDemo
//
//  Created by Adrian Bilescu on 03.04.2025.
//

import SwiftUI

struct UsersListView<StoryView: View>: View {
    @ViewBuilder
    let storyView: (User) -> StoryView
    @ObservedObject var viewModel: UsersListViewModel
    var users: [User] {
        viewModel.users
    }
    
    var isLoading: Bool {
        viewModel.isLoading
    }
    
    var error: Error? {
        viewModel.error
    }
    
    var selectedUser: User? {
        viewModel.selectedUser
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if isLoading && users.isEmpty {
                    ProgressView()
                } else if let error {
                    makeRetryView(error: error)
                } else {
                    makeUsersList()
                }
            }
            .navigationTitle("Stories")
        }
        .task {
            if users.isEmpty {
                await viewModel.loadInitialUsers()
            }
        }
        .fullScreenCover(item: $viewModel.selectedUser) { selectedUser in
            storyView(selectedUser)
        }
    }
    
    @ViewBuilder
    private func makeRetryView(error: Error) -> some View {
        SomethingWentWrongView(error: error, retry: {
            Task {
                await viewModel.loadInitialUsers()
            }
        })
    }
    
    @ViewBuilder
    private func makeUsersList() -> some View {
        Form {
            List(users) { user in
                Button {
                    withAnimation {
                        viewModel.selectedUser = user
                    }
                } label: {
                    UserRow(user: user)
                }
                .foregroundStyle(.foreground)
            }
        }
        .refreshable {
            await viewModel.refreshUsers()
        }
    }
}



#Preview {
    UsersListView(
        storyView: { user in
            StoriesView(
                viewModel: StoriesListViewModel(
                    user: user,
                    storiesFetcher: StubFetchStoriesUseCase()
                )
            )
        },
        viewModel: UsersListViewModel(
            fetcher: StubFetchUsersUseCase.makeSuccess(count: 12)
        )
    )
}

#Preview("Failure") {
    UsersListView(
        storyView: { _ in
            Text("No view")
        },
        viewModel: UsersListViewModel(
            fetcher: StubFetchUsersUseCase
                .makeFailure(error: NoStoriesFoundError())
        )
    )
}


