//
//  SuperPACTileView.swift
//  VoteVault
//

import SwiftUI

// MARK: - Super PAC Tile View (New)
struct SuperPACTileView: View {
    let expenditure: SuperPACExpenditure
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(expenditure.committee_name ?? "Unknown Committee")
                .font(.headline)
            
            InfoRow(label: "Amount", value: formatCurrencyShorthand(expenditure.total))
        }
        .padding(.vertical)
    }
}
