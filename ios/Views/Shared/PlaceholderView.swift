//
//  PlaceholderView.swift
//  VoteVault
//

import SwiftUI

struct PlaceholderView: View {
    var title: String
    
    var body: some View {
        VStack {
            Text("\(title) view is under construction.")
                .font(.title2)
                .foregroundColor(.gray)
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
