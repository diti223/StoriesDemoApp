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
                    VStack {
                        Text("Something went wrong")
                        Text(error.localizedDescription)
                            .font(.caption)
                        
                        Button("Try Again") {
                            Task {
                                await viewModel.loadInitialUsers()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else {
                    List(users) { user in
                        Button {
							//TODO: implement
                        } label: {
                            UserRow(user: user)
                        }
                        .buttonStyle(.plain)
                    }
                    .listStyle(.plain)
                    .refreshable {
                        await viewModel.refreshUsers()
                    }
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
}

struct UserRow: View {
    let user: User
    
    var body: some View {
        HStack {
            AsyncImage(url: user.profilePictureURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            
            Text(user.name)
                .font(.headline)
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    UsersListView(
        viewModel: UsersListViewModel(
            fetcher: StubFetchUsersUseCase.makeSuccess()
        )
    )
    UsersListView(
        viewModel: UsersListViewModel(
            fetcher: StubFetchUsersUseCase.makeFailure(error: NoStoriesFoundError())
        )
    )
}
