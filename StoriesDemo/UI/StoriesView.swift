//
//  StoriesView.swift
//  StoriesDemo
//
//  Created by Adrian Bilescu on 03.04.2025.
//

import SwiftUI

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
                Spacer()
                Text("Stories from \(user.name)")
                Spacer()
            }
        }
        .foregroundStyle(.white)
    }
}
