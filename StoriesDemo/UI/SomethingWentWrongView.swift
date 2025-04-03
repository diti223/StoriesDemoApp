//
//  SomethingWentWrongView.swift
//  StoriesDemo
//
//  Created by Adrian Bilescu on 03.04.2025.
//

import SwiftUI

struct SomethingWentWrongView: View {
    let error: Error
    let retry: () -> Void
    
    var body: some View {
        VStack {
            Text("Something went wrong")
            Text(error.localizedDescription)
                .font(.caption)
            
            Button("Try Again") {
                retry()
            }
            .buttonStyle(.borderedProminent)
        }
    }
}
