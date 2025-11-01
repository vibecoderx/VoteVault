//
//  FinancialRow.swift
//  VoteVault
//

import SwiftUI

struct FinancialRow: View {
    let label: String
    let amount: Double
    
    var body: some View {
        HStack {
            Text(label)
            Spacer()
            // Updated logic to show 'K' for thousands and 'M' for millions
            if amount < 1_000_000 {
                Text("$\(Int(amount / 1_000))K")
                    .fontWeight(.semibold)
            } else {
                Text("$\(Int(amount / 1_000_000))M")
                    .fontWeight(.semibold)
            }
        }
        .font(.footnote)
    }
}
