//
//  UserRow.swift
//  StoriesDemo
//
//  Created by Adrian Bilescu on 03.04.2025.
//

import SwiftUI

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
