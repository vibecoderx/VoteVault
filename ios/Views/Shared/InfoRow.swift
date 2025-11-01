//
//  InfoRow.swift
//  VoteVault
//

import SwiftUI

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text("\(label):")
                .fontWeight(.bold)
            Text(value)
        }
    }
}
