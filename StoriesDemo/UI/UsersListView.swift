//
//  UsersListView.swift
//  StoriesDemo
//
//  Created by Adrian Bilescu on 03.04.2025.
//

import SwiftUI

struct UsersListView: View {
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
                    //TODO: implement
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
        viewModel: UsersListViewModel(
            fetcher: StubFetchUsersUseCase.makeSuccess(count: 12)
        )
    )
}

#Preview("Failure") {
    UsersListView(
        viewModel: UsersListViewModel(
            fetcher: StubFetchUsersUseCase
                .makeFailure(error: NoStoriesFoundError())
        )
    )
}
