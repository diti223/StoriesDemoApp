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
            StoriesView(user: selectedUser, close: {
                viewModel.selectedUser = nil
            })
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


struct StoriesView: View {
    let user: User
    let close: () -> Void
    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea()
            VStack {
                HStack {
                 	Spacer()
                    Button.init(action: close, label: {
                        Label.init("", systemImage: "xmark")
                            .font(.headline)
                            .bold()
                    })
                    .padding()
                }
                Spacer()
                Text("Stories from \(user.name)")
                Spacer()
            }
        }
        .foregroundStyle(.white)
    }
}
